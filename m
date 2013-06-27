Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3F0Uy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:54:26 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:63804 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3F0UyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:54:25 -0400
Message-ID: <51CCA67C.2010803@gmail.com>
Date: Thu, 27 Jun 2013 15:54:20 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, x86@kernel.org, arm@kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-xtensa@linux-xtensa.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] of: Specify initrd location using 64-bit
References: <1371775956-16453-1-git-send-email-santosh.shilimkar@ti.com> <51C4171C.9050908@linutronix.de> <51C48B5A.2040404@ti.com>
In-Reply-To: <51C48B5A.2040404@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:20 PM, Santosh Shilimkar wrote:
> On Friday 21 June 2013 05:04 AM, Sebastian Andrzej Siewior wrote:
>> On 06/21/2013 02:52 AM, Santosh Shilimkar wrote:
>>> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
>>> index 0a2c68f..62e2e8f 100644
>>> --- a/arch/microblaze/kernel/prom.c
>>> +++ b/arch/microblaze/kernel/prom.c
>>> @@ -136,8 +136,7 @@ void __init early_init_devtree(void *params)
>>>  }
>>>  
>>>  #ifdef CONFIG_BLK_DEV_INITRD
>>> -void __init early_init_dt_setup_initrd_arch(unsigned long start,
>>> -		unsigned long end)
>>> +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
>>>  {
>>>  	initrd_start = (unsigned long)__va(start);
>>>  	initrd_end = (unsigned long)__va(end);
>>
>> I think it would better to go here for phys_addr_t instead of u64. This
>> would force you in of_flat_dt_match() to check if the value passed from
>> DT specifies a memory address outside of 32bit address space and the
>> kernel can't deal with this because its phys_addr_t is 32bit only due
>> to a Kconfig switch.
>>
>> For x86, the initrd has to remain in the 32bit address space so passing
>> the initrd in the upper range would violate the ABI. Not sure if this
>> is true for other archs as well (ARM obviously not).
>>
> That pretty much means phys_addr_t. It will work for me as well but
> in last thread from consistency with memory and reserved node, Rob
> insisted to keep it as u64. So before I re-spin another version,
> would like to here what Rob has to say considering the x86 requirement.
> 
> Rob,
> Are you ok with phys_addr_t since your concern was about rest
> of the memory specific bits of the device-tree code use u64 ?

No. I still think it should be u64 for same reasons I said originally.

Rob

