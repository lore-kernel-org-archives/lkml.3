Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3DVHD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:03:58 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33823 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3DVHD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:03:56 -0400
Message-ID: <5174E0C3.505@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 12:33:31 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] powerpc, perf: Add new BHRB related instructions
 for POWER8
References: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com> <1366287976-3900-2-git-send-email-khandual@linux.vnet.ibm.com> <20130421234109.GC22246@concordia> <14010.1366593223@ale.ozlabs.ibm.com> <20130422024546.GA24739@concordia> <14063.1366599003@ale.ozlabs.ibm.com>
In-Reply-To: <14063.1366599003@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042206-5564-0000-0000-00000799B191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 08:20 AM, Michael Neuling wrote:
> Michael Ellerman <michael@ellerman.id.au> wrote:
> 
>> On Mon, Apr 22, 2013 at 11:13:43AM +1000, Michael Neuling wrote:
>>> Michael Ellerman <michael@ellerman.id.au> wrote:
>>>
>>>> On Thu, Apr 18, 2013 at 05:56:12PM +0530, Anshuman Khandual wrote:
>>>>> This patch adds new POWER8 instruction encoding for reading
>>>>> the BHRB buffer entries and also clearing it. Encoding for
>>>>> "clrbhrb" instruction is straight forward.
>>>>
>>>> Which is "clear branch history rolling buffer" ?
>>>>
>>>>> But "mfbhrbe"
>>>>> encoding involves reading a certain index of BHRB buffer
>>>>> into a particular GPR register.
>>>>
>>>> And "Move from branch history rolling buffer entry" ?
>>>>
>>>>> diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
>>>>> index 8752bc8..93ae5a1 100644
>>>>> --- a/arch/powerpc/include/asm/ppc-opcode.h
>>>>> +++ b/arch/powerpc/include/asm/ppc-opcode.h
>>>>> @@ -82,6 +82,7 @@
>>>>>  #define	__REGA0_R31	31
>>>>>  
>>>>>  /* sorted alphabetically */
>>>>> +#define PPC_INST_BHRBE			0x7c00025c
>>>>
>>>> I don't think you really need this, just use the literal value below.
>>>
>>> The rest of the defines in this file do this, so Anshuman's right. 
>>
>> I don't see the point, but sure let's be consistent. Though in that case
>> he should do the same for PPC_CLRBHRB below.
> 
> Agreed.
> 

Sure, would define a new macro (PPC_INST_CLRBHRB) to encode 0x7c00035c
before using it for PPC_CLRBHRB.

> Mikey
> 
>>
>>>>> @@ -297,6 +298,12 @@
>>>>>  #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
>>>>>  #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
>>>>>  
>>>>> +/* BHRB instructions */
>>>>> +#define PPC_CLRBHRB		stringify_in_c(.long 0x7c00035c)
>>>>> +#define PPC_MFBHRBE(r, n)	stringify_in_c(.long PPC_INST_BHRBE | \
>>>>> +						__PPC_RS(r) | \
>>>>> +							(((n) & 0x1f) << 11))
>>>>
>>>> Why are you not using ___PPC_RB(n) here ?
>>>
>>> Actually, this is wrong.  The number field should be 10 bits (0x3ff),
>>> not 5 (0x1f)  Anshuman please fix.
>>
>> ACK.

I got it wrong, thought this as 32 instead of 1024. Would fix it.

Regards
Anshuman

