Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3DWPDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:03:50 -0400
Received: from smtp3.nethome.no ([92.62.33.13]:52317 "EHLO smtp.nethome.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab3DWPDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Apr 2013 17:03:31 +0200
From: peterasplund@gentoo.se
To: Kent Yoder <shpedoikal@gmail.com>
Cc: <Peter.Huewe@infineon.com>, <mail@srajiv.net>, <aaron.lu@intel.com>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [tpmdd-devel] =?UTF-8?Q?tpm=5Ftis=20driver=20failed=20to=20su?=
 =?UTF-8?Q?spend=2C=20error=20-=36=32?=
In-Reply-To: <20130423144309.GA11692@gmail.com>
References: <ed364e68730267510d49b2bdc38679a0@gentoo.se>
 <CAEQAOwpmnLXBCJQTf_xU-oSKvAtmpQjHWwMYDm_QOsP+1Kd_aQ@mail.gmail.com>
 <CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
 <51540408.3000702@intel.com>
 <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
 <733a6b303b7e9a3c4fb396acad9d9c5c@gentoo.se>
 <CAM0nabGXCfNipOHhzhoFT-yAN-RDOZG9EObQCY-QdRM5LfMCfQ@mail.gmail.com>
 <d9741eb17fbc5731469a79b8bca3ed07@gentoo.se>
 <20130411214141.GA12814@gmail.com>
 <ec94e98bae36890a39e6c332e0dd74c5@gentoo.se>
 <20130423144309.GA11692@gmail.com>
Message-ID: <e5f4563e58ecbe575d4ac315d1310695@gentoo.se>
User-Agent: Roundcube Webmail/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-23 16:43 skrev Kent Yoder:
> On Tue, Apr 23, 2013 at 04:30:53PM +0200, peterasplund@gentoo.se 
> wrote:
>> 2013-04-11 23:41 skrev Kent Yoder:
>> >On Sat, Apr 06, 2013 at 06:00:59PM +0200, peterasplund@gentoo.se
>> >wrote:
>> >>2013-04-02 16:03 skrev Kent Yoder:
>> >>>Hi Peter,
>> >>>
>> >>>On Mon, Apr 1, 2013 at 4:17 PM,  <peterasplund@gentoo.se> wrote:
>> >>>>2013-03-28 14:12 skrev Peter.Huewe@infineon.com:
>> >>>>>What also might be worth a look - in your bugzilla it states:
>> >>>>>[ 0.225891] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102
>> >>>>>PNP0c31
>> >>>>>(active)
>> >>>>>[ 9.150673] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
>> >>>>>[ 9.292148] tpm_tis 00:0a: Adjusting TPM timeout parameters.
>> >>>>>[ 10.084067] tpm_tis 00:0a: A TPM error (7) occurred
>> >>attempting to
>> >>>>>read a pcr
>> >>>>>value
>> >>>>>[ 10.084077] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
>> >>>>>
>> >>>>>
>> >>>>>Can you perhaps try to enable your TPM in the BIOS? It's quite
>> >>>>>often
>> >>>>>hidden under "embedded security device" or "system security".
>> >>>>>Quite often you have to have a bios password set to access 
>> these
>> >>>>>settings.
>> >>>>>If your system does not have bios support for TPMs, please
>> >>>>>tell me so
>> >>>>>and I'll try to help you out.
>> >>>>>
>> >>>>
>> >>>>I've enabled it in BIOS now, and the output seems to be a bit
>> >>>>different. Not too uplifting though...
>> >>>>
>> >>>>root@zepto:/home/peter# dmesg | grep tpm
>> >>>>[   14.631662] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> >>>>[   14.748276] tpm_tis 00:08: Adjusting TPM timeout parameters.
>> >>>>[   34.908128] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> >>>>[  125.992108] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> >>>>[  212.908502] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> >>>>root@zepto:/home/peter# tpm_version
>> >>>>Tspi_Context_Connect failed: 0x00003011 - layer=tsp, code=0011
>> >>(17),
>> >>>>Communication failure
>> >>>>root@zepto:/home/peter# tcsd -f
>> >>>>TCSD TDDL ioctl: (25) Inappropriate ioctl for device
>> >>>>TCSD TDDL Falling back to Read/Write device support.
>> >>>>TCSD TDDL ERROR: write to device /dev/tpm0 failed: Timer expired
>> >>>>TCSD TCS ERROR: TCS GetCapability failed with result = 0x1087
>> >>>
>> >>>  Can you cat /sys/class/misc/tpm0/device/timeouts? Ivan Pryvalov
>> >>>reported that his TPM showed values that were too small to keep
>> >>from
>> >>>causing timeouts waiting on TPM commands, but too big to
>> >>trigger the
>> >>>driver's code to scale them.  (He saw 12000 for the 3 timeout
>> >>>values.)
>> >>>
>> >>Hi Kent
>> >>
>> >>The values I'm seeing are:
>> >>
>> >>root@zepto:~# cat /sys/class/misc/tpm0/device/timeouts
>> >>752000 2000000 752000 752000 [adjusted]
>> >>
>> >>So I guess these are within a normal range?
>> >
>> >  Yes, these look normal. So it seems you can send commands to the
>> >TPM
>> >up until you try to suspend?  Can you try to cat other files like
>> >/sys/class/misc/tpm0/device/pcrs? This is the simplest way to send
>> >some
>> >command to the TPM...
>> >
>> >Kent
>> >
>>
>> Hi Kent, I'm sorry I haven't replied to this message before. I must
>> have missed it!
>>
>> root@zepto:/sys/class/misc/tpm0# ll
>> drwxr-xr-x 3 root root    0 Apr 23 16:20 ./
>> drwxr-xr-x 3 root root    0 Apr 23 16:20 ../
>> -r--r--r-- 1 root root 4096 Apr 23 16:26 dev
>> lrwxrwxrwx 1 root root    0 Apr 23 16:26 device -> ../../../00:08/
>> drwxr-xr-x 2 root root    0 Apr 23 16:26 power/
>> lrwxrwxrwx 1 root root    0 Apr 23 16:20 subsystem ->
>> ../../../../../class/misc/
>> -rw-r--r-- 1 root root 4096 Apr 23 16:20 uevent
>>
>> root@zepto:/sys/class/misc/tpm0# cat dev
>> 10:224
>> root@zepto:/sys/class/misc/tpm0# cat device/pcrs   (prints nothing
>> after a delay of a second or so)
>> root@zepto:/sys/class/misc/tpm0# cat uevent
>> MAJOR=10
>> MINOR=224
>> DEVNAME=tpm0
>> root@zepto:/sys/class/misc/tpm0# cat device/active
>> root@zepto:/sys/class/misc/tpm0# cat device/cancel
>> cat: device/cancel: Permission denied
>> root@zepto:/sys/class/misc/tpm0# cat device/caps
>> root@zepto:/sys/class/misc/tpm0# cat device/durations
>> 1000000 4000000 152000000 [adjusted]
>> root@zepto:/sys/class/misc/tpm0# cat device/enabled
>> root@zepto:/sys/class/misc/tpm0# cat device/id
>> IFX0102
>> PNP0c31
>> root@zepto:/sys/class/misc/tpm0# cat device/options
>> root@zepto:/sys/class/misc/tpm0# cat device/owned
>> root@zepto:/sys/class/misc/tpm0# cat device/pubek
>> root@zepto:/sys/class/misc/tpm0# cat device/resources
>> state = active
>> mem 0xfed40000-0xfed44fff
>> io 0x4e-0x4f
>> io 0x1670-0x167f
>> irq 11
>> root@zepto:/sys/class/misc/tpm0# cat device/temp_deactivated
>> root@zepto:/sys/class/misc/tpm0# cat device/timeouts
>> 752000 2000000 752000 752000 [adjusted]
>> root@zepto:/sys/class/misc/tpm0# cat device/uevent
>> DRIVER=tpm_tis
>>
>> To be able to do the 'cat' above, I usually need to restart my
>> computer, otherwise the files aren't there. That's probably after
>> I've put the computer in sleep mode (which works if I add tpm_tis to
>> the module blacklist). Perhaps the same problem is related to this
>> one:
>> I just did a grep of my dmesg and saw some new error messages (28)
>> in it. Perhaps they started occurring after I enabled it in BIOS.
>>
>> root@zepto:/home/peter# dmesg | grep tpm_
>> [   11.369198] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [   11.508115] tpm_tis 00:08: Adjusting TPM timeout parameters.
>> [   32.560040] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> [ 4320.577827] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [ 4320.636111] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the timeouts
>
>   Your TPM failed its internal self test (rc=28).  At this point it 
> will
> have gone shut down. Looks like your hardware is broken. :(
>
> Kent

But this only seems to happen after the tpm module has been unloaded 
when going to sleep. I don't get these messages after a reboot:
root@zepto:/sys/class/misc/tpm0# dmesg | grep tpm
[   12.068202] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[   12.212122] tpm_tis 00:08: Adjusting TPM timeout parameters.
[   33.068050] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  434.500088] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  485.180079] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  511.436081] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  523.412084] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  535.396083] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  550.316068] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  559.164074] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  570.028078] tpm_tis 00:08: tpm_transmit: tpm_send: error -62

/Peter

>
>> [ 4320.696081] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the durations
>> [ 4320.696091] tpm_tis 00:08: Could not get TPM timeouts and 
>> durations
>> [ 9279.692915] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [ 9279.756184] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the timeouts
>> [ 9279.822186] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the durations
>> [ 9279.822197] tpm_tis 00:08: Could not get TPM timeouts and 
>> durations
>> [10968.845856] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [10968.904111] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the timeouts
>> [10968.964100] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the durations
>> [10968.964111] tpm_tis 00:08: Could not get TPM timeouts and 
>> durations
>> [13304.341746] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [13304.400093] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the timeouts
>> [13304.464134] tpm_tis 00:08: A TPM error (28) occurred attempting
>> to determine the durations
>> [13304.464142] tpm_tis 00:08: Could not get TPM timeouts and 
>> durations
>>
>> Thank you,
>> Peter A
>>
>>
>> >>Thanks,
>> >>Peter
>> >>
>> >>> If you're seeing similar values, can you try the attached patch?
>> >>>
>> >>>Thanks,
>> >>>Kent
>> >>>
>> >>>>/Peter A
>> >>>>
>> >>>>
>> >>
>> 
>> >>>>------------------------------------------------------------------------------
>> >>>>Own the Future-Intel&reg; Level Up Game Demo Contest 2013
>> >>>>Rise to greatness in Intel's independent game demo contest.
>> >>>>Compete for recognition, cash, and the chance to get your game
>> >>>>on Steam. $5K grand prize plus 10 genre and skill prizes.
>> >>>>Submit your demo by 6/6/13. http://p.sf.net/sfu/intel_levelupd2d
>> >>>>_______________________________________________
>> >>>>tpmdd-devel mailing list
>> >>>>tpmdd-devel@lists.sourceforge.net
>> >>>>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
