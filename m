Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbbA0UOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:14:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589AbbA0UOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:14:12 -0500
Message-ID: <54C7F180.1030505@oracle.com>
Date: Tue, 27 Jan 2015 15:13:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v2 3/3] mm: cma: release trigger
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com> <1422282365-20015-4-git-send-email-sasha.levin@oracle.com> <20150127081012.GD11358@js1304-P5Q-DELUXE> <54C7D801.3070502@oracle.com>
In-Reply-To: <54C7D801.3070502@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 01:25 PM, Sasha Levin wrote:
> On 01/27/2015 03:10 AM, Joonsoo Kim wrote:
>>> >> +		if (mem->n <= count) {
>>>> >> > +			cma_release(cma, mem->p, mem->n);
>>>> >> > +			count -= mem->n;
>>>> >> > +			kfree(mem);
>>>> >> > +		} else {
>>>> >> > +			cma_release(cma, mem->p, count);
>>>> >> > +			mem->p += count;
>>>> >> > +			mem->n -= count;
>>>> >> > +			count = 0;
>>>> >> > +			cma_add_to_cma_mem_list(mem);
>>>> >> > +		}
>>>> >> > +	}
>> > If order_per_bit is not 0 and count used in cma_release() is
>> > different with the count used in cma_alloc(), problem could
>> > occur since bitmap management code can't handle that situation.
>> > 
>> > Could we just disable this case in this testing module?
> How should it behave then? Just free a max of 'count' pages and
> stop beforehand if we're going to go over it?

Actually, Can I just check for order_per_bit == 0 and execute it
then? I don't want to avoid testing these paths.


Thanks,
Sasha
