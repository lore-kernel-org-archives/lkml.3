Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3LDQk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:40:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42750 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3LDQkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:40:24 -0500
Message-ID: <529F5ACF.7010105@arm.com>
Date: Wed, 04 Dec 2013 16:39:43 +0000
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: Ming Lei <tom.leiming@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: default PHYS_OFFSET if !MMU
References: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com> <1384341351-4110-2-git-send-email-tom.leiming@gmail.com> <528366A9.7060504@arm.com>
In-Reply-To: <528366A9.7060504@arm.com>
X-OriginalArrivalTime: 04 Dec 2013 16:40:22.0208 (UTC) FILETIME=[8667DC00:01CEF10F]
X-MC-Unique: 113120416402210401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 13/11/13 11:46, Jonathan Austin wrote:
> Hi Ming,
>
> On 13/11/13 11:15, Ming Lei wrote:
>> From: Jonathan Austin <jonathan.austin@arm.com>
>>
>> Set CONFIG_PAGE_OFFSET as PHYS_OFFSET when !MMU so that
>> we can keep CONFIG_PAGE_OFFSET same with PAGE_OFFSET.
>>
>
> I'm not so sure about this commit message - I don't think
> it makes sense...Should it not be more like:
>
> ------->8-------
> Subject: ARM: set PAGE_OFFSET = PHYS_OFFSET if !MMU
>
> With !MMU we still set PAGE_OFFSET to 0xC0000000, which
> makes little sense and causes a regression on !MMU after
> f6537f2f0eba4eba ("scripts/kallsyms: filter symbols not
> kernel address space")
>
> This patch sets PAGE_OFFSET to PHYS_OFFSET in the !MMU
> case, fixing the regression (Tested on Cortex-R7/Vexpress)
> --------8<---------
>
> Russell: Will you pick this patch up from the list or does
> it need to go in through the patch system?


What's the status of this patch? Shall I put it in the patch system with 
the commit message above? Or is it going via someone else?

Jonny

>
> Jonny
>
>> This patch and patch 2/2 fix regression on !MMU by
>> f6537f2f0eba4eba("scripts/kallsyms: filter symbols not
>> in kernel address space")
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>    arch/arm/Kconfig |    1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 799ef94..db708c4 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1560,6 +1560,7 @@ endchoice
>>
>>    config PAGE_OFFSET
>>    	hex
>> +	default PHYS_OFFSET if !MMU
>>    	default 0x40000000 if VMSPLIT_1G
>>    	default 0x80000000 if VMSPLIT_2G
>>    	default 0xC0000000
>>
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>


