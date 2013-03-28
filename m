Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3C1IsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:48:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:60417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab3C1Irz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,924,1355126400"; 
   d="scan'208";a="219780343"
Message-ID: <51540408.3000702@intel.com>
Date: Thu, 28 Mar 2013 16:49:12 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rajiv Andrade <mail@srajiv.net>, peterasplund@gentoo.se
CC: Luigi Semenzato <semenzato@google.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, key@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] tpm_tis driver failed to suspend, error -62
References: <20130319023440.GA12425@aaronlu.sh.intel.com> <CAA25o9RJJ5Rkti9_fTJz2ieaHvrtSp5mE_2LTW_t16_cf_TNcg@mail.gmail.com> <ed364e68730267510d49b2bdc38679a0@gentoo.se> <CAEQAOwpmnLXBCJQTf_xU-oSKvAtmpQjHWwMYDm_QOsP+1Kd_aQ@mail.gmail.com> <CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
In-Reply-To: <CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 11:22 PM, Rajiv Andrade wrote:
> Hey Aaron,
> 
> Sorry for the delay. Can you send us the dmesg output after setting
> loglevel=7 at boot time? Additionally, can you send us the TPM
> manufacturer model/version?
> 
> # cat /sys/devices/pnp0/00\:0*/caps
> 
> Adding Kent.

Thanks Rajiv.

Peter,
Please kindly provide the required information, thanks.

-Aaron

> 
> Cheers,
> Rajiv
> 
> On Wed, Mar 27, 2013 at 12:17 PM, Rajiv Andrade <mail@srajiv.net> wrote:
>> Hey Aaron,
>>
>> Sorry for the delay. Can you send us the dmesg output after setting
>> loglevel=7 at boot time? Additionally, can you send us the TPM manufacturer
>> model/version?
>>
>> # cat /sys/devices/pnp0/00\:0*/caps
>>
>> Adding Kent.
>>
>> Cheers,
>> Rajiv
>>
>>
>> On Thu, Mar 21, 2013 at 10:17 AM, <peterasplund@gentoo.se> wrote:
>>>
>>> Hi! Sadly, I have to say that I'm totally oblivious to power-related stuff
>>> both in software and hardware, so I have no idea what you are asking or
>>> proposing.. :)
>>>
>>> I don't know if you have access to the files I've included in the bug
>>> report, so here are the links to them:
>>> https://launchpadlibrarian.net/105830773/lspci.txt
>>> https://launchpadlibrarian.net/95994294/AcpiTables.txt
>>> https://launchpadlibrarian.net/95994318/BootDmesg.txt
>>> https://launchpadlibrarian.net/95994354/UdevDb.txt
>>>
>>> Regarding the syslog during boot, is that the same as the BootDmesg I've
>>> attached? Or should I search in another log file?
>>> I'm not sure about the model, but I was hoping you could deduct something
>>> from the UdevDb or the lspci output above.
>>>
>>> BR,
>>> Peter
>>>
>>> 2013-03-19 16:50 skrev Luigi Semenzato:
>>>
>>>> Error 62 is ETIME.  The driver is timing out during a tpm_send,
>>>> possibly trying to send the Tpm_SaveState command.
>>>>
>>>> It may be that you cannot talk to the TPM at all.  Have you tried
>>>> sending messages to the TPM before suspending?
>>>>
>>>> Are there any other tpm entries in the syslog?  Like at boot?
>>>>
>>>> What model TPM is it?
>>>>
>>>>
>>>> On Mon, Mar 18, 2013 at 7:34 PM, Aaron Lu <aaron.lu@intel.com> wrote:
>>>>>
>>>>> Hi Rajiv,
>>>>>
>>>>> Not sure if I should send this to you, please kindly forward it to the
>>>>> appropriate person if not, thanks.
>>>>>
>>>>> Peter has encountered a problem during suspend, the tpm_tis driver's
>>>>> suspend callback will fail, the relevant message is:
>>>>>
>>>>> [  192.281757] PM: Syncing filesystems ... done.
>>>>> [  192.692479] Freezing user space processes ... (elapsed 0.01 seconds)
>>>>> done.
>>>>> [  192.708159] Freezing remaining freezable tasks ... (elapsed 0.01
>>>>> seconds)
>>>>> done.
>>>>> [  192.724151] Suspending console(s) (use no_console_suspend to debug)
>>>>> [  192.724612] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>>>>> [  192.724785] sd 2:0:0:0: [sda] Stopping disk
>>>>> [  197.512047] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>>>>> [  197.512055] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
>>>>> [  197.512057] PM: Device 00:08 failed to suspend: error -62
>>>>> [  197.512058] PM: Some devices failed to suspend
>>>>>
>>>>> And the problem has been there since v2.6.32(shipped in ubuntu 10.04),
>>>>> and the latest upstream tree(v3.9-rcx) also has this problem. The bug
>>>>> link is here:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=45761
>>>>>
>>>>> Please feel free to ask for more information, thanks.
>>>>>
>>>>> -Aaron
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> ------------------------------------------------------------------------------
>>>>> Everyone hates slow websites. So do we.
>>>>> Make your web apps faster with AppDynamics
>>>>> Download AppDynamics Lite for free today:
>>>>> http://p.sf.net/sfu/appdyn_d2d_mar
>>>>> _______________________________________________
>>>>> tpmdd-devel mailing list
>>>>> tpmdd-devel@lists.sourceforge.net
>>>>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>>
>>

