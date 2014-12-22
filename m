Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaLVKZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:25:42 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:24147 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbaLVKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:25:41 -0500
Message-ID: <5497F1A3.7060004@c-s.fr>
Date: Mon, 22 Dec 2014 11:25:39 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [v2 PATCH 1/2] powerpc32: adds handling of _PAGE_RO
References: <20141217091431.D3F761A5E0D@localhost.localdomain> <1418868868.5581.121.camel@freescale.com>
In-Reply-To: <1418868868.5581.121.camel@freescale.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 18/12/2014 03:14, Scott Wood a écrit :
> On Wed, 2014-12-17 at 10:14 +0100, Christophe Leroy wrote:
>> Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
>> This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> ---
>> v2 is a complete rework compared to v1
>>
>>   arch/powerpc/include/asm/pgtable-ppc32.h | 11 ++++++-----
>>   arch/powerpc/include/asm/pgtable.h       | 10 +++++++---
>>   arch/powerpc/include/asm/pte-common.h    | 27 ++++++++++++++++++---------
>>   arch/powerpc/mm/gup.c                    |  2 ++
>>   arch/powerpc/mm/mem.c                    |  2 +-
>>   arch/powerpc/mm/pgtable_32.c             | 24 ++++++++++++++++++++----
>>   6 files changed, 54 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
>> index 543bb8e..64ed9e1 100644
>> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
>> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
>> @@ -125,7 +125,7 @@ extern int icache_44x_need_flush;
>>   #ifndef __ASSEMBLY__
>>   
>>   #define pte_clear(mm, addr, ptep) \
>> -	do { pte_update(ptep, ~_PAGE_HASHPTE, 0); } while (0)
>> +	do { pte_update(ptep, ~_PAGE_HASHPTE, _PAGE_RO); } while (0)
> Is this really necessary?  It's already clearing the valid bit.
>
> Likewise in several other places that set or check for _PAGE_RO on pages
> for which no access is permitted.
>
>
You are right, this is not needed. I needed it because I had defined 
pte_none() as requiring _PAGE_RO set. But we can keep value 0 as 
pte_none. Taken into account in v3

Christophe
