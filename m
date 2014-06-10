Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264AbaFJDVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:21:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:46155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbaFJDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1006,1392192000"; 
   d="scan'208";a="552990428"
Message-ID: <53967992.2020808@linux.intel.com>
Date: Tue, 10 Jun 2014 11:20:50 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 11/42] x86, ioapic: kill unused global variable timer_through_8259
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-12-git-send-email-jiang.liu@linux.intel.com> <alpine.LFD.2.11.1406091538320.14982@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.11.1406091538320.14982@eddie.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/6/9 22:41, Maciej W. Rozycki wrote:
> On Mon, 9 Jun 2014, Jiang Liu wrote:
> 
>> index d4aba16e6bbf..94a56c233e87 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -2638,8 +2638,6 @@ static int __init disable_timer_pin_setup(char *arg)
>>  }
>>  early_param("disable_timer_pin_1", disable_timer_pin_setup);
>>  
>> -int timer_through_8259 __initdata;
>> -
>>  /*
>>   * This code may look a bit paranoid, but it's supposed to cooperate with
>>   * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
>> @@ -2744,7 +2742,6 @@ static inline void __init check_timer(void)
>>  		legacy_pic->unmask(0);
>>  		if (timer_irq_works()) {
>>  			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
>> -			timer_through_8259 = 1;
>>  			goto out;
>>  		}
>>  		/*
> 
>  So how does the new NMI watchdog handle systems that use this '8259A 
> Virtual Wire' mode, pretty common on pre-P6 computers?
Hi Maciej,
	We just kill the useless variable "timer_through_8259", 8259 virtual
wire mode is still supported.
Thanks!
Gerry

> 
>   Maciej
> 
