Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbbA0SZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:25:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbA0SZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:25:19 -0500
Message-ID: <54C7D801.3070502@oracle.com>
Date: Tue, 27 Jan 2015 13:25:05 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v2 3/3] mm: cma: release trigger
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com> <1422282365-20015-4-git-send-email-sasha.levin@oracle.com> <20150127081012.GD11358@js1304-P5Q-DELUXE>
In-Reply-To: <20150127081012.GD11358@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 03:10 AM, Joonsoo Kim wrote:
>> +		if (mem->n <= count) {
>> > +			cma_release(cma, mem->p, mem->n);
>> > +			count -= mem->n;
>> > +			kfree(mem);
>> > +		} else {
>> > +			cma_release(cma, mem->p, count);
>> > +			mem->p += count;
>> > +			mem->n -= count;
>> > +			count = 0;
>> > +			cma_add_to_cma_mem_list(mem);
>> > +		}
>> > +	}
> If order_per_bit is not 0 and count used in cma_release() is
> different with the count used in cma_alloc(), problem could
> occur since bitmap management code can't handle that situation.
> 
> Could we just disable this case in this testing module?

How should it behave then? Just free a max of 'count' pages and
stop beforehand if we're going to go over it?


Thanks,
Sasha
