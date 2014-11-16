Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaKPIhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:37:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:46468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaKPIho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:37:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487810432"
Message-ID: <54686255.5040907@linux.intel.com>
Date: Sun, 16 Nov 2014 16:37:41 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Nov 14
References: <20141114192738.08e744cc@canb.auug.org.au> <20141115211922.GA2347@roeck-us.net> <54680D0A.7070900@linux.intel.com> <5468185D.5020400@roeck-us.net> <54682618.1070508@linux.intel.com> <54684A9E.90606@roeck-us.net> <54685F39.3060007@linux.intel.com>
In-Reply-To: <54685F39.3060007@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/16 16:24, Jiang Liu wrote:
> On 2014/11/16 14:56, Guenter Roeck wrote:
>> On 11/15/2014 08:20 PM, Jiang Liu wrote:
>>
>> I took the configuration file I had for the SMP case (located in the same
>> directory in the git repository), disabled SMP, and ran "make
>> savedefconfig".
>> "old" is relative in this context; I don't usually create new configuration
>> files for each new kernel release, so, yes, you could say that the file
>> I used is "old".
>>
>> CONFIG_X86_LOCAL_APIC is enabled. Keep in mind this is a configuration file
>> created with "make savedefconfig", so default settings are not included.
>> Correct, CONFIG_X86_IO_APIC is not enabled, but that is not really
>> surprising
>> since its dependencies are not met as far as I can see.
>>
>> Overall, I am not sure I understand what you are trying to say. X86_IO_APIC
>> depends on X86_64 (not set) or SMP (not set) or X86_32_NON_STANDARD (not
>> set)
>> or X86_UP_IOAPIC (not set because it depends on X86_UP_APIC which
>> depends on
>> !PCI_MSI).
>>
>> Does that mean that I'll have to disable PCI_MSI to get x86 uniprocessor
>> support to work after your patch ?
> Hi Guenter,
> 	Previously, X86_IO_APIC will be enabled if PCI_MSI is enabled.
> With my patch, x86_IO_APIC may be disabled even if PCI_MSI is enabled.
> If X86_LOCAL_APIC/PCI_MSI are enabled and X86_IO_APIC is disabled, it
> should work theoretically. I remember it works on my HP laptop.
> Could you please help to check whether it solve the issue by manually
> turning on X86_IO_APIC?
Or could you please help to apply this patch?
http://patchwork.ozlabs.org/patch/408402/

> Thanks!
> Gerry
> 
>>
>> Thanks,
>> Guenter
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
