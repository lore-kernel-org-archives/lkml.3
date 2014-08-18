Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaHRNNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:13:08 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:63837 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaHRNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:13:06 -0400
Date: Mon, 18 Aug 2014 09:13:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: tangchen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
Message-ID: <20140818131301.GA16425@mtj.dyndns.org>
References: <53E8C5AA.5040506@huawei.com>
 <20140816130456.GH9305@htj.dyndns.org>
 <53EF6C79.3000603@huawei.com>
 <20140817110821.GM9305@htj.dyndns.org>
 <53F15330.5070606@cn.fujitsu.com>
 <53F17068.5000005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F17068.5000005@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Xishi, Tang.

On Mon, Aug 18, 2014 at 11:18:00AM +0800, Xishi Qiu wrote:
> If all the nodes are marked hotpluggable flag, alloc node data will fail.
> Because __next_mem_range_rev() will skip the hotpluggable memory regions.
> numa_register_memblks()
> 	setup_node_data()
> 		memblock_find_in_range_node()
> 			__memblock_find_range_top_down()
> 				for_each_mem_range_rev()
> 					__next_mem_range_rev()

I'm not sure clearing hotplug flag for all memory is the best approach
here.  The problem is that there are places where we want to be
selectively ignoring the hotplug status and apparently we may want it
back later.  Why not add an agument to memblock allocation / iteration
functions so that hotplug area can be skipped selectively?

Thanks.

-- 
tejun
