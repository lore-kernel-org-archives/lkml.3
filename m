Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaKPG4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 01:56:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52627 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaKPG4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 01:56:43 -0500
Message-ID: <54684A9E.90606@roeck-us.net>
Date: Sat, 15 Nov 2014 22:56:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Nov 14
References: <20141114192738.08e744cc@canb.auug.org.au> <20141115211922.GA2347@roeck-us.net> <54680D0A.7070900@linux.intel.com> <5468185D.5020400@roeck-us.net> <54682618.1070508@linux.intel.com>
In-Reply-To: <54682618.1070508@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.54684AAA.0122,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2014 08:20 PM, Jiang Liu wrote:
>
> On 2014/11/16 11:22, Guenter Roeck wrote:
>> On 11/15/2014 06:33 PM, Jiang Liu wrote:
>>> Hi Guenter,
>>>      Could you please help to provide the config file and
>>> error messages?
>>
>> Config file:
>>      https://github.com/groeck/linux-build-test/blob/master/rootfs/x86/qemu_x86_pc_nosmp_defconfig
> Hi Guenter,
> 	Thanks for help. According to the above configuration file:
> CONFIG_PCI_MSI is enabled, but CONFIG_X86_LOCAL_APIC and
> CONFIG_X86_IO_APIC are both disabled. But the Kconfig for X86_LOCAL_APIC
> is defined as:
> config X86_LOCAL_APIC
>          def_bool y
>          depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
> || PCI_MSI
>          select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
>
> That means CONFIG_X86_LOCAL_APIC should be enabled if CONFIG_PCI_MSI is
> enabled. So how did you generate the qemu_x86_pc_nosmp_defconfig? Are
> you using an old configuration file?

I took the configuration file I had for the SMP case (located in the same
directory in the git repository), disabled SMP, and ran "make savedefconfig".
"old" is relative in this context; I don't usually create new configuration
files for each new kernel release, so, yes, you could say that the file
I used is "old".

CONFIG_X86_LOCAL_APIC is enabled. Keep in mind this is a configuration file
created with "make savedefconfig", so default settings are not included.
Correct, CONFIG_X86_IO_APIC is not enabled, but that is not really surprising
since its dependencies are not met as far as I can see.

Overall, I am not sure I understand what you are trying to say. X86_IO_APIC
depends on X86_64 (not set) or SMP (not set) or X86_32_NON_STANDARD (not set)
or X86_UP_IOAPIC (not set because it depends on X86_UP_APIC which depends on
!PCI_MSI).

Does that mean that I'll have to disable PCI_MSI to get x86 uniprocessor
support to work after your patch ?

Thanks,
Guenter

