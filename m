Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbbA2NEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:04:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43652 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbbA2NEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:04:49 -0500
Message-ID: <54CA2FE3.1000001@oracle.com>
Date: Thu, 29 Jan 2015 08:04:35 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v3 3/3] mm: cma: release trigger
References: <1422411777-22332-1-git-send-email-sasha.levin@oracle.com> <1422411777-22332-4-git-send-email-sasha.levin@oracle.com> <20150129075130.GB19607@js1304-P5Q-DELUXE>
In-Reply-To: <20150129075130.GB19607@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 02:51 AM, Joonsoo Kim wrote:
> On Tue, Jan 27, 2015 at 09:22:57PM -0500, Sasha Levin wrote:
>> > +static int cma_free_mem(struct cma *cma, int count)
>> > +{
>> > +	struct cma_mem *mem = NULL;
>> > +
>> > +	while (count) {
>> > +		mem = cma_get_entry_from_list(cma);
>> > +		if (mem == NULL)
>> > +			return 0;
>> > +
>> > +		if (mem->n <= count) {
>> > +			cma_release(cma, mem->p, mem->n);
>> > +			count -= mem->n;
>> > +			kfree(mem);
>> > +		} else if (cma->order_per_bit == 0) {
>> > +			cma_release(cma, mem->p, count);
>> > +			mem->p += count;
>> > +			mem->n -= count;
>> > +			count = 0;
>> > +			cma_add_to_cma_mem_list(cma, mem);
>> > +		} else {
>> > +			cma_add_to_cma_mem_list(cma, mem);
>> > +			break;
>> > +		}
>> > +	}
> Hmm... I'm not sure we need to deal with "mem->m < count" case.
> It is not suitable for any cma_alloc/release usecase.

Maybe not, but the code in mm/cma.c supports that right now. If that
ever changes we can make appropriate changes here.

> And, I'd like to insert some error log to last case rather than
> silently ignoring the request.

I can add that.


Thanks,
Sasha
