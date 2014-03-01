Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaCARbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:31:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:47156 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbaCARbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:31:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="scan'208";a="492184925"
Message-ID: <53121961.2080209@linux.intel.com>
Date: Sun, 02 Mar 2014 01:31:13 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <531027BE.2010807@linux.intel.com> <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org>
In-Reply-To: <20140301172256.GA29417@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/2 1:22, Matthew Garrett wrote:
> On Sun, Mar 02, 2014 at 01:10:46AM +0800, Li, Aubrey wrote:
> 
>> Peter - Can you please clarify writing to cf9 caused some system hang.
>> If CF9 is the last way to try, that means ACPI, KBD takes no effect,
>> then if no CF9, the system hangs there in  infinite for() loop. If CF9
>> is there, that means CF9 takes no effect as well, CF9 does *NOT* cause
>> system hang, right? If the answer is no, can you please point me which
>> system hangs by CF9. I'd like to investigate what the ACPI reboot
>> vectors look like on these systems.
> 
> I think I'm fine with cf9 being in there as long as it comes after the 
> ACPI calls and as long as we're using either conf1 or conf2 access.
> 
>> I know, cf9 is not an architectural way, twice ACPI call has no spec
> 
>> (1) ACPI
>> (2) keyboard
>> (3) ACPI
>> (4) keyboard
>> (5) FADT sleep register as long as it's valid(!=0)
>> (6) FADT sleep registers once again(since we try ACPI twice)
> 
> ACPI is the FADT sleep register - there's no separate ACPI reboot call. 
> Do you mean try this again even if the valid bit isn't set?

Yes. we already have a case that the registers is valid without the bit set.

> 
>> (7) EFI (interesting, I found it's eventually CF9 on some my
>> investigated systems. No need to wait Matt's patch, it gives a chance to
>> reboot 32bit kernel on 32bit EFI today)
> 
> No. The EFI reboot call jumps into the firmware and executes code.

Firmware actually writes CF9.


> We don't want to do that until we ensure that there's an appropriate 
> mapping in place because the consequences could be unpleasent. There is 
> code to do this, let's just wait until it's merged.

The design philosophy is as above. We didn't confirm, we try, we try to
match the user's final requirement. And it can be successful on 32bit
linux&EFI system. Do you have an explicit unpleasant result share with me?

> 
>> Also, we should add if a new method is emerged, instead of keeping
>> adding those freak/endless reboot dmidecode table. Those quirks were not
>> supposed to be in the kernel. We should remove them.
> 
> Hey I am absolutely fine with removing DMI lists under almost all 
> circumstances.
> 
I'm glad to hear this, :)

Thanks,
-Aubrey
