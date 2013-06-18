Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3FRBp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:45:27 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:63032 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3FRBpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:45:25 -0400
Date: Mon, 17 Jun 2013 18:45:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 14/22] x86, mm, numa: Set memblock nid later
Message-ID: <20130618014518.GX32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-15-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-15-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:03:01PM +0800, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> In order to seperate parsing numa info procedure into two steps,

Short "why" would be nice.

> we need to set memblock nid later because it could change memblock
                                   ^
				   in where?

> array, and possible doube memblock.memory array which will allocate
             ^
	     possibly double

> buffer.

 which is bad why?

> Only set memblock nid once for successful path.
> 
> Also rename numa_register_memblks to numa_check_memblks() after
> moving out code of setting memblock nid.
> @@ -676,6 +669,11 @@ void __init x86_numa_init(void)
>  
>  	early_x86_numa_init();
>  
> +	for (i = 0; i < mi->nr_blks; i++) {
> +		struct numa_memblk *mb = &mi->blk[i];
> +		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
> +	}
> +

Can we please have some comments explaining the new ordering
requirements?  When reading code, how is one supposed to know that the
ordering of operations is all deliberate and fragile?

Thanks.

-- 
tejun
