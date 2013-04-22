Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3DVG5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:57:54 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36933 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3DVG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:57:53 -0400
Message-ID: <5174DF58.7020506@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 12:27:28 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] powerpc, perf: Add new BHRB related instructions
 for POWER8
References: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com> <1366287976-3900-2-git-send-email-khandual@linux.vnet.ibm.com> <20130421234109.GC22246@concordia>
In-Reply-To: <20130421234109.GC22246@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042206-4790-0000-0000-000007F51627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 05:11 AM, Michael Ellerman wrote:
> On Thu, Apr 18, 2013 at 05:56:12PM +0530, Anshuman Khandual wrote:
>> This patch adds new POWER8 instruction encoding for reading
>> the BHRB buffer entries and also clearing it. Encoding for
>> "clrbhrb" instruction is straight forward.
> 
> Which is "clear branch history rolling buffer" ?
> 
>> But "mfbhrbe"
>> encoding involves reading a certain index of BHRB buffer
>> into a particular GPR register.
> 
> And "Move from branch history rolling buffer entry" ?
> 

Sure, would add these descriptions in the change log.

>> diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
>> index 8752bc8..93ae5a1 100644
>> --- a/arch/powerpc/include/asm/ppc-opcode.h
>> +++ b/arch/powerpc/include/asm/ppc-opcode.h
>> @@ -82,6 +82,7 @@
>>  #define	__REGA0_R31	31
>>  
>>  /* sorted alphabetically */
>> +#define PPC_INST_BHRBE			0x7c00025c
> 
> I don't think you really need this, just use the literal value below.
> 
>> @@ -297,6 +298,12 @@
>>  #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
>>  #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
>>  
>> +/* BHRB instructions */
>> +#define PPC_CLRBHRB		stringify_in_c(.long 0x7c00035c)
>> +#define PPC_MFBHRBE(r, n)	stringify_in_c(.long PPC_INST_BHRBE | \
>> +						__PPC_RS(r) | \
>> +							(((n) & 0x1f) << 11))
> 
> Why are you not using ___PPC_RB(n) here ?
> 

I would replace __PPC_RS(r) with __PPC_RT(r) which makes more sense from
instruction encoding point of view.

Regards
Anshuman

