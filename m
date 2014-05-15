Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaEOJhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:37:19 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754402AbaEOJhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:37:13 -0400
Message-ID: <53748AC3.9080709@nod.at>
Date: Thu, 15 May 2014 11:37:07 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/27] arm64: Override defaults from generic/tlb.h
References: <1400093999-18703-1-git-send-email-richard@nod.at> <1400093999-18703-2-git-send-email-richard@nod.at> <20140515093430.GE11117@localhost>
In-Reply-To: <20140515093430.GE11117@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.05.2014 11:34, schrieb Catalin Marinas:
> On Wed, May 14, 2014 at 07:59:33PM +0100, Richard Weinberger wrote:
>> --- a/arch/arm64/include/asm/tlb.h
>> +++ b/arch/arm64/include/asm/tlb.h
>> @@ -19,7 +19,14 @@
>>  #ifndef __ASM_TLB_H
>>  #define __ASM_TLB_H
>>  
>> +/* These defines are needed to override the defaults from asm-generic/tlb.h */
>>  #define  __tlb_remove_pmd_tlb_entry __tlb_remove_pmd_tlb_entry
>> +#define tlb_start_vma tlb_start_vma
>> +#define tlb_end_vma tlb_end_vma
>> +#define __tlb_remove_tlb_entry __tlb_remove_tlb_entry
>> +#define tlb_flush tlb_flush
>> +#define __pte_free_tlb __pte_free_tlb
>> +#define __pmd_free_tlb __pmd_free_tlb
>>  
>>  #include <asm-generic/tlb.h>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I hope subsequent series would consolidate some more of the above (for
> example tlb_start_vma() is not really arm64 specific.

Yes, peterz pointed me to a not jet merged series which consolidates
much more.
I'll revive it.

Thanks,
//richard
