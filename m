Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423496Ab3FURN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:13:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40697 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423404Ab3FURNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:13:54 -0400
Message-ID: <51C48986.6080602@ti.com>
Date: Fri, 21 Jun 2013 13:12:38 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <x86@kernel.org>, <arm@kernel.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <bigeasy@linutronix.de>,
        <robherring2@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-c6x-dev@linux-c6x.org>,
        <linux-mips@linux-mips.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-xtensa@linux-xtensa.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] of: Specify initrd location using 64-bit
References: <1371775956-16453-1-git-send-email-santosh.shilimkar@ti.com> <51C3D8E7.5030601@synopsys.com> <51C40D78.4040603@imgtec.com>
In-Reply-To: <51C40D78.4040603@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet, James,

On Friday 21 June 2013 04:23 AM, James Hogan wrote:
> On 21/06/13 05:39, Vineet Gupta wrote:
>> Hi Santosh,
>>
>> On 06/21/2013 06:22 AM, Santosh Shilimkar wrote:
>>> Cc: Vineet Gupta <vgupta@synopsys.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: Mark Salter <msalter@redhat.com>
>>> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
>>> Cc: James Hogan <james.hogan@imgtec.com>
>>> Cc: Michal Simek <monstr@monstr.eu>
>>> Cc: Ralf Baechle <ralf@linux-mips.org>
>>> Cc: Jonas Bonn <jonas@southpole.se>
>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Cc: Paul Mackerras <paulus@samba.org>
>>> Cc: x86@kernel.org
>>> Cc: arm@kernel.org
>>> Cc: Chris Zankel <chris@zankel.net>
>>> Cc: Max Filippov <jcmvbkbc@gmail.com>
>>> Cc: Grant Likely <grant.likely@linaro.org>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: bigeasy@linutronix.de
>>> Cc: robherring2@gmail.com
>>> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
>>>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-c6x-dev@linux-c6x.org
>>> Cc: linux-mips@linux-mips.org
>>> Cc: linuxppc-dev@lists.ozlabs.org
>>> Cc: linux-xtensa@linux-xtensa.org
>>> Cc: devicetree-discuss@lists.ozlabs.org
>>>
>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>>>  arch/arc/mm/init.c            |    3 +--
>>>  arch/arm/mm/init.c            |    2 +-
>>>  arch/arm64/mm/init.c          |    3 +--
>>>  arch/c6x/kernel/devicetree.c  |    3 +--
>>>  arch/metag/mm/init.c          |    3 +--
>>>  arch/microblaze/kernel/prom.c |    3 +--
>>>  arch/mips/kernel/prom.c       |    3 +--
>>>  arch/openrisc/kernel/prom.c   |    3 +--
>>>  arch/powerpc/kernel/prom.c    |    3 +--
>>>  arch/x86/kernel/devicetree.c  |    3 +--
>>>  arch/xtensa/kernel/setup.c    |    3 +--
>>>  drivers/of/fdt.c              |   10 ++++++----
>>>  include/linux/of_fdt.h        |    3 +--
>>>  13 files changed, 18 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
>>> index 4a17736..3640c74 100644
>>> --- a/arch/arc/mm/init.c
>>> +++ b/arch/arc/mm/init.c
>>> @@ -157,8 +157,7 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
>>>  #endif
>>>  
>>>  #ifdef CONFIG_OF_FLATTREE
>>> -void __init early_init_dt_setup_initrd_arch(unsigned long start,
>>> -					    unsigned long end)
>>> +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
>>>  {
>>>  	pr_err("%s(%lx, %lx)\n", __func__, start, end);
>>>  }
>>
>> To avoid gcc warnings, you need to fix the print format specifiers too.
> 
> The same thing goes for arch/metag too.
> 
Will update that in next version based on what we will end
after the dicussion. i.e u64 or phys_addr_t

Thanks for comments.

Regards,
Santosh
