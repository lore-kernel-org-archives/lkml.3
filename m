Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3LMV3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:29:19 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54094 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LMV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:29:18 -0500
Date: Fri, 13 Dec 2013 16:29:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 07/23] mm/memblock: switch to use NUMA_NO_NODE instead
 of MAX_NUMNODES
Message-ID: <20131213212912.GL27070@htj.dyndns.org>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
 <1386625856-12942-8-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386625856-12942-8-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:50:40PM -0500, Santosh Shilimkar wrote:
> +	if (nid == MAX_NUMNODES)
> +		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
> +			     __func__);

Why not just use WARN_ONCE()?  We'd want to know who the caller is
anyway.  Also, wouldn't something like the following simpler?

	if (WARN_ONCE(nid == MAX_NUMNODES, blah blah))
		nid = NUMA_NO_NODE;

> @@ -768,6 +773,11 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
>  	struct memblock_type *rsv = &memblock.reserved;
>  	int mi = *idx & 0xffffffff;
>  	int ri = *idx >> 32;
> +	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
> +
> +	if (nid == MAX_NUMNODES)
> +		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
> +			     __func__);

Ditto.

Provided the patch is tested on an actual NUMA setup.

Reviwed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
