Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaRow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:44:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:37083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaAaRov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:44:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="447757750"
Message-ID: <52EBE112.5010203@intel.com>
Date: Fri, 31 Jan 2014 09:44:50 -0800
From: "Kamble, Nitin A" <nitin.a.kamble@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: fix a Kconfig dependency
References: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com> <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com> <alpine.DEB.2.02.1401310223460.7183@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401310223460.7183@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 1/31/2014 2:27 AM, David Rientjes wrote:
> On Thu, 30 Jan 2014, nitin.a.kamble@intel.com wrote:
>
>> From: Nitin A Kamble <nitin.a.kamble@intel.com>
>>
>> The generic_chip.c uses interfaces from irq_domain.c which is controlled by
>> the IRQ_DOMAIN config option.
>>
>> Add a select statement in the Kconfig to reflect this requirement.
>>
>> Without this fix, the generic_chip.c compilation fails like this:
>>
>> linux/kernel/irq/generic-chip.c:400:11:
>>    error: 'irq_domain_xlate_onetwocell' undeclared here (not in a function)
>>
> You're not specifying which config option you have enabled that selects
> CONFIG_GENERIC_IRQ_CHIP and does not select CONFIG_IRQ_DOMAIN, but it does
> look like there is a dependency here.
It is enabled by GPIO_PCH as seen here:

config GPIO_PCH
         tristate "Intel EG20T PCH/LAPIS Semiconductor 
IOH(ML7223/ML7831) GPIO"
         depends on PCI && X86
         select GENERIC_IRQ_CHIP
         help
           This driver is for PCH(Platform controller Hub) GPIO of Intel 
Topcliff
           which is an IOH(Input/Output Hub) for x86 embedded processor.
           This driver can access PCH GPIO device.

>
> So, if this dependency is reasonable, it begs the question of why we have
> CONFIG_GENERIC_IRQ_CHIP at all and shouldn't just make generic-chip.c
> depend on CONFIG_IRQ_DOMAIN.
Looking at the code there are cases where IRQ_DOMAIN functionality is used
without using the GENERIC_IRQ_CHIP. So making generic-chip.c depend
on CONFIG_IRQ_DOMAIN in the makefile will reduce the flexibility of using
these config options separately.

Nitin


