Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab3E1OE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:04:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45503 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab3E1OE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:04:28 -0400
Message-ID: <51A4B938.7080708@ti.com>
Date: Tue, 28 May 2013 19:33:36 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Po-Yu Chuang <ratbert.chuang@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com> <20130528130502.GA28971@mudshark.cambridge.arm.com>
In-Reply-To: <20130528130502.GA28971@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 06:35 PM, Will Deacon wrote:
> On Tue, May 28, 2013 at 11:48:20AM +0100, Po-Yu Chuang wrote:
>> This bug was introduced in commit e651eab0.
>> Some v4/v5 platforms failed to boot due to this.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert.chuang@gmail.com>
>> ---
>>  arch/arm/mm/mmu.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>> index e0d8565..19a43f8 100644
>> --- a/arch/arm/mm/mmu.c
>> +++ b/arch/arm/mm/mmu.c
>> @@ -620,6 +620,8 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
>>  			unsigned long end, phys_addr_t phys,
>>  			const struct mem_type *type)
>>  {
>> +	pmd_t *p = pmd;
>> +
>>  #ifndef CONFIG_ARM_LPAE
>>  	/*
>>  	 * In classic MMU format, puds and pmds are folded in to
>> @@ -638,7 +640,7 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
>>  		phys += SECTION_SIZE;
>>  	} while (pmd++, addr += SECTION_SIZE, addr != end);
>>  
>> -	flush_pmd_entry(pmd);
>> +	flush_pmd_entry(p);
> Wait, shouldn't this flush be *inside* the loop anyway? Otherwise we just
> flush the cacheline containing the first pmd. The flushing code could also
> flush to PoU instead of PoC for UP ARMv7, but that's an unrelated optimisation.
   I think in LPAE this loop iterates once and non LPAE twice.
   So both the entries should be contained in same cache line right ?

Regards,
 Sricharan
