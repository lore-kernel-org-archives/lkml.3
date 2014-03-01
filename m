Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaCARKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:10:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:27931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaCARKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:10:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="scan'208";a="344828902"
Message-ID: <53121496.8060603@linux.intel.com>
Date: Sun, 02 Mar 2014 01:10:46 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53100C8D.1060001@linux.intel.com> <20140228045637.GA28257@srcf.ucam.org> <53101D1D.9010202@linux.intel.com> <20140228055629.GA847@srcf.ucam.org> <531027BE.2010807@linux.intel.com> <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com>
In-Reply-To: <53110977.8080907@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/1 6:11, Li, Aubrey wrote:
> On 2014/3/1 1:47, H. Peter Anvin wrote:
>> On 02/27/2014 10:54 PM, Li, Aubrey wrote:
>>> On 2014/2/28 14:44, Matthew Garrett wrote:
>>>> On Fri, Feb 28, 2014 at 02:39:56PM +0800, Li, Aubrey wrote:
>>>>
>>>>> Just let you know, Windows8.1 calls EFI on these boxes for reboot/shutdown.
>>>>
>>>> Ok, in that case we should add EFI reboot to the list once Matt's 1:1 
>>>> mapping support has landed. The right place to try it is probably after 
>>>> the second attempt to perform an ACPI reboot. I'm still not enthusiastic 
>>>> about adding cf9 by default.
>>>>
>>>
>>> I'll defer to you if no one on the list supports me to add cf9.
>>>
>>
>> I believe we *had* it in the default list for a while, and it caused
>> hangs on some systems.

Well, keep pressing the power button for 20 seconds to power off my
ASUS-T100 makes me to re-read this thread.

Peter - Can you please clarify writing to cf9 caused some system hang.
If CF9 is the last way to try, that means ACPI, KBD takes no effect,
then if no CF9, the system hangs there in  infinite for() loop. If CF9
is there, that means CF9 takes no effect as well, CF9 does *NOT* cause
system hang, right? If the answer is no, can you please point me which
system hangs by CF9. I'd like to investigate what the ACPI reboot
vectors look like on these systems.

I know, cf9 is not an architectural way, twice ACPI call has no spec
support as well.

Please remember, reboot/power off is the last service Linux kernel can
do for our users, why can't we just make it more robust?

IMHO, we should try all of the way we know. Don't worry, we are in the
shutdown context so we don't have a chance to break any other OS components.

Again, I'd like to suggest we try all of the known methods in the
default list, unless you have a functional reason to object.

(1) ACPI
(2) keyboard
(3) ACPI
(4) keyboard
(5) FADT sleep register as long as it's valid(!=0)
(6) FADT sleep registers once again(since we try ACPI twice)
(7) EFI (interesting, I found it's eventually CF9 on some my
investigated systems. No need to wait Matt's patch, it gives a chance to
reboot 32bit kernel on 32bit EFI today)
(8) CF9
(9) BIOS
(10) TRIPLE

Also, we should add if a new method is emerged, instead of keeping
adding those freak/endless reboot dmidecode table. Those quirks were not
supposed to be in the kernel. We should remove them.

Welcome any comments.

Thanks,
-Aubrey

> 
> So this can be finalized, add EFI after twice ACPI reboot attempt. I'll
> update the bugzilla and the patch.
> 
> Thanks,
> -Aubrey
>>
>> 	-hpa
>>
>>
> 

