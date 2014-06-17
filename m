Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaFQB0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:26:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36959 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaFQB0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:26:41 -0400
Message-ID: <539F98AC.9050105@huawei.com>
Date: Tue, 17 Jun 2014 09:23:56 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Thumb-2: Fix out-of-range offset for Thumb-2 in,
 proc-macros.S
References: <5396ACF1.1020107@huawei.com> <20140616134908.GI16758@arm.com>
In-Reply-To: <20140616134908.GI16758@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/16 21:49, Will Deacon wrote:
> On Tue, Jun 10, 2014 at 08:00:01AM +0100, Wang Weidong wrote:
>> The STR Instruction Encoding T4 points that the <imm> is in the
>> range 0-255.So split the instruction into two for Thumb-2. Just
>> like commit 874d5d3ccc("ARM: 6623/1: Thumb-2: Fix out-of-range
>> offset for Thumb-2 in proc-v7.S").
>>
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>  arch/arm/mm/proc-macros.S | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
>> index ee1d805..63f710c 100644
>> --- a/arch/arm/mm/proc-macros.S
>> +++ b/arch/arm/mm/proc-macros.S
>> @@ -252,7 +252,9 @@
>>  	tst	r3, #L_PTE_PRESENT | L_PTE_YOUNG	@ present and young?
>>  	movne	r2, #0				@ no -> fault
>>  
>> -	str	r2, [r0, #2048]!		@ hardware version
>> + ARM(	str	r2, [r0, #2048]! 		) @ hardware version
>> + THUMB( add	r0, r0, #2048 			)
>> + THUMB( str	r2, [r0] 			)
>>  	mov	ip, #0
>>  	mcr	p15, 0, r0, c7, c10, 1		@ clean L1 D line
>>  	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
> 
> AFAICT this is in xscale_set_pte_ext_epilogue which should only be built as
> ARM. Are you seeing a real issue here?
> 
> Will
> 

Hi will,

I don't see any issue here. I just review the codes while I learn thumb-2.
It does only build as ARM, so ignore it.

Regards
Wang

> .
> 


