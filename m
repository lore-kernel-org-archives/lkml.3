Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423247Ab3DFQBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:01:07 -0400
Received: from smtp3.nethome.no ([92.62.33.13]:36873 "EHLO smtp.nethome.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423221Ab3DFQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:01:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Apr 2013 18:00:59 +0200
From: peterasplund@gentoo.se
To: Kent Yoder <shpedoikal@gmail.com>
Cc: <Peter.Huewe@infineon.com>, <mail@srajiv.net>, <aaron.lu@intel.com>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [tpmdd-devel] =?UTF-8?Q?tpm=5Ftis=20driver=20failed=20to=20su?=
 =?UTF-8?Q?spend=2C=20error=20-=36=32?=
In-Reply-To: <CAM0nabGXCfNipOHhzhoFT-yAN-RDOZG9EObQCY-QdRM5LfMCfQ@mail.gmail.com>
References: <20130319023440.GA12425@aaronlu.sh.intel.com>
 <CAA25o9RJJ5Rkti9_fTJz2ieaHvrtSp5mE_2LTW_t16_cf_TNcg@mail.gmail.com>
 <ed364e68730267510d49b2bdc38679a0@gentoo.se>
 <CAEQAOwpmnLXBCJQTf_xU-oSKvAtmpQjHWwMYDm_QOsP+1Kd_aQ@mail.gmail.com>
 <CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
 <51540408.3000702@intel.com>
 <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
 <733a6b303b7e9a3c4fb396acad9d9c5c@gentoo.se>
 <CAM0nabGXCfNipOHhzhoFT-yAN-RDOZG9EObQCY-QdRM5LfMCfQ@mail.gmail.com>
Message-ID: <d9741eb17fbc5731469a79b8bca3ed07@gentoo.se>
User-Agent: Roundcube Webmail/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-02 16:03 skrev Kent Yoder:
> Hi Peter,
>
> On Mon, Apr 1, 2013 at 4:17 PM,  <peterasplund@gentoo.se> wrote:
>> 2013-03-28 14:12 skrev Peter.Huewe@infineon.com:
>>> What also might be worth a look - in your bugzilla it states:
>>> [ 0.225891] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 
>>> PNP0c31
>>> (active)
>>> [ 9.150673] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
>>> [ 9.292148] tpm_tis 00:0a: Adjusting TPM timeout parameters.
>>> [ 10.084067] tpm_tis 00:0a: A TPM error (7) occurred attempting to
>>> read a pcr
>>> value
>>> [ 10.084077] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
>>>
>>>
>>> Can you perhaps try to enable your TPM in the BIOS? It's quite 
>>> often
>>> hidden under "embedded security device" or "system security".
>>> Quite often you have to have a bios password set to access these
>>> settings.
>>> If your system does not have bios support for TPMs, please tell me 
>>> so
>>> and I'll try to help you out.
>>>
>>
>> I've enabled it in BIOS now, and the output seems to be a bit
>> different. Not too uplifting though...
>>
>> root@zepto:/home/peter# dmesg | grep tpm
>> [   14.631662] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [   14.748276] tpm_tis 00:08: Adjusting TPM timeout parameters.
>> [   34.908128] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> [  125.992108] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> [  212.908502] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>> root@zepto:/home/peter# tpm_version
>> Tspi_Context_Connect failed: 0x00003011 - layer=tsp, code=0011 (17),
>> Communication failure
>> root@zepto:/home/peter# tcsd -f
>> TCSD TDDL ioctl: (25) Inappropriate ioctl for device
>> TCSD TDDL Falling back to Read/Write device support.
>> TCSD TDDL ERROR: write to device /dev/tpm0 failed: Timer expired
>> TCSD TCS ERROR: TCS GetCapability failed with result = 0x1087
>
>   Can you cat /sys/class/misc/tpm0/device/timeouts? Ivan Pryvalov
> reported that his TPM showed values that were too small to keep from
> causing timeouts waiting on TPM commands, but too big to trigger the
> driver's code to scale them.  (He saw 12000 for the 3 timeout 
> values.)
>
Hi Kent

The values I'm seeing are:

root@zepto:~# cat /sys/class/misc/tpm0/device/timeouts
752000 2000000 752000 752000 [adjusted]

So I guess these are within a normal range?

Thanks,
Peter

>  If you're seeing similar values, can you try the attached patch?
>
> Thanks,
> Kent
>
>> /Peter A
>>
>> 
>> ------------------------------------------------------------------------------
>> Own the Future-Intel&reg; Level Up Game Demo Contest 2013
>> Rise to greatness in Intel's independent game demo contest.
>> Compete for recognition, cash, and the chance to get your game
>> on Steam. $5K grand prize plus 10 genre and skill prizes.
>> Submit your demo by 6/6/13. http://p.sf.net/sfu/intel_levelupd2d
>> _______________________________________________
>> tpmdd-devel mailing list
>> tpmdd-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
