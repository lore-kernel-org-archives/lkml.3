Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaDRVOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaDRVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:14:38 -0400
Message-ID: <535195AC.1070702@redhat.com>
Date: Fri, 18 Apr 2014 17:14:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>, akpm@linux-foundation.org,
        minchan@kernel.org, hannes@cmpxchg.org, shli@kernel.org,
        bob.liu@oracle.com, sjenning@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, aquini@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, khalid.aziz@oracle.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: cleanup *lru_cache_add* functions
References: <1397835565-6411-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1397835565-6411-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 11:39 AM, Jianyu Zhan wrote:
> Hi, Christoph Hellwig,
> 
>> There are no modular users of lru_cache_add, so please don't needlessly
>> export it.
> 
> yep, I re-checked and found there is no module user of neither 
> lru_cache_add() nor lru_cache_add_anon(), so don't export it.
> 
> Here is the renewed patch:
> ---
> 
> In mm/swap.c, __lru_cache_add() is exported, but actually there are
> no users outside this file. However, lru_cache_add() is supposed to
> be used by vfs, or whatever others, but it is not exported.
> 
> This patch unexports __lru_cache_add(), and makes it static.
> It also exports lru_cache_add_file(), as it is use by cifs, which
> be loaded as module.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
