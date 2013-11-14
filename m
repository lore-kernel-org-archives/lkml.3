Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3KNJjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:39:22 -0500
Received: from intranet.asianux.com ([58.214.24.6]:22103 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3KNJjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:39:19 -0500
X-Spam-Score: -100.8
Message-ID: <52849ACA.1060301@asianux.com>
Date: Thu, 14 Nov 2013 17:41:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-metag@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: kernel: dma.c: check 'pud' whether is NULL
 in dma_alloc_init()
References: <528485A9.5050509@asianux.com> <52849706.3010309@huawei.com>
In-Reply-To: <52849706.3010309@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 05:25 PM, Xishi Qiu wrote:
> On 2013/11/14 16:11, Chen Gang wrote:
> 
>> Like another p?d_alloc(), pud_alloc() also may fail, so need check it.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/metag/kernel/dma.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/metag/kernel/dma.c b/arch/metag/kernel/dma.c
>> index db589ad..e6cf39b 100644
>> --- a/arch/metag/kernel/dma.c
>> +++ b/arch/metag/kernel/dma.c
>> @@ -398,6 +398,11 @@ static int __init dma_alloc_init(void)
>>  		int offset = pgd_index(CONSISTENT_START);
>>  		pgd = pgd_offset(&init_mm, CONSISTENT_START);
>>  		pud = pud_alloc(&init_mm, pgd, CONSISTENT_START);
>> +		if (!pud) {
>> +			pr_err("%s: no pud tables\n", __func__);
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
> 
> It looks fine to me.
> 

Thank you too.

James has his opinion about it, we are just discussing, welcome you
join.

:-)


Thanks.

> Thanks,
> Xishi Qiu
> 
>>  		pmd = pmd_alloc(&init_mm, pud, CONSISTENT_START);
>>  		if (!pmd) {
>>  			pr_err("%s: no pmd tables\n", __func__);
> 
> 
> 
> 
-- 
Chen Gang
