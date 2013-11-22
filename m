Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3KVJ5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:57:31 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:58457 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3KVJ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:57:29 -0500
Message-ID: <528F2A85.4090808@gmail.com>
Date: Fri, 22 Nov 2013 10:57:25 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: rafael.j.wysocki@intel.com
CC: Jingoo Han <jg1.han@samsung.com>, "'Borislav Petkov'" <bp@alien8.de>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com> <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com> <20131118133210.GG24851@pd.tnic> <528B36EA.20301@gmail.com> <20131119101521.GA3515@pd.tnic> <528C84A1.5030707@gmail.com> <20131120111541.GA30147@pd.tnic> <528DC2AA.4070202@gmail.com> <20131121101234.GB25459@pd.tnic> <000801cee6ab$4e9f9380$ebdeba80$%han@samsung.com> <528F0B1E.6000909@gmail.com>
In-Reply-To: <528F0B1E.6000909@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/11/2013 08:43, Francis Moreau a écrit :
> Le 21/11/2013 12:17, Jingoo Han a écrit :
> [...]
>>>
>>>> Also I took a look at the changes between v3.11 and v3.12 in this area
>>>> and those changes match the issue I'm facing:
>>>>
>>>> $ git log --oneline v3.11..v3.12 -- drivers/mfd/rtsx_pcr.c
>>>> 09fd867 mfd: rtsx: Copyright modifications
>>>> eb891c6 mfd: rtsx: Configure to enter a deeper power-saving mode in S3
>>>> 7140812 mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual
>>>> extra_init_hw
>>>> 5947c16 mfd: rtsx: Add shutdown callback in rtsx_pci_driver
>>>> 773ccdf mfd: rtsx: Read vendor setting from config space
>>
>> In my opinion, rtsx_pci_resume()/rtsx_pci_suspend() in realtek PCIe card
>> reader driver may make the kernel panic.
>>
>> I think that the commit "mfd: rtsx: Configure to enter a deeper
>> power-saving mode in S3" may be the culprit.
> 
> Unfortunately no, reverting this commit on top of v3.12 doesn't help. I
> also reverted 7140812, 5947c16 but it didn't improve anything.
> 
> The good news is that I managed to have a "light" kernel configuration
> which is faster to build and more important it seems that the bug is
> almost 100% reproductible now.
> 
> So I'll try to do another git-bisect session later.

So after bisecting between v3.11..v3.12 range, git bisect told me:

the first bad commit is 551f5c74e17ba9257cdc35bf657ee448cad2d5b0

Merge branch 'acpi-processor'

    * acpi-processor:
      ACPI / processor: Acquire writer lock to update CPU maps
      ACPI / processor: Remove acpi_processor_get_limit_info()

The two commits brought by the merge are not the culprits because
reseting HEAD on "ACPI / processor: Acquire writer lock to update CPU
maps" doesn't have the issue anymore.

At that point I'm not sure how to bisect futher.

Hope that helps.

Thanks
