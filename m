Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaHQLI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 07:08:26 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63871 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaHQLIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 07:08:25 -0400
Date: Sun, 17 Aug 2014 07:08:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
Message-ID: <20140817110821.GM9305@htj.dyndns.org>
References: <53E8C5AA.5040506@huawei.com>
 <20140816130456.GH9305@htj.dyndns.org>
 <53EF6C79.3000603@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EF6C79.3000603@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 16, 2014 at 10:36:41PM +0800, Xishi Qiu wrote:
> numa_clear_node_hotplug()? There is only numa_clear_kernel_node_hotplug().

Yeah, that one.

> If we don't clear hotpluggable flag in free_low_memory_core_early(), the 
> memory which marked hotpluggable flag will not free to buddy allocator.
> Because __next_mem_range() will skip them.
> 
> free_low_memory_core_early
> 	for_each_free_mem_range
> 		for_each_mem_range
> 			__next_mem_range		

Ah, okay, so the patch fixes __next_mem_range() and thus makes
free_low_memory_core_early() to skip hotpluggable regions unlike
before.  Please explain things like that in the changelog.  Also,
what's its relationship with numa_clear_kernel_node_hotplug()?  Do we
still need them?  If so, what are the different roles that these two
separate places serve?

Thanks.

-- 
tejun
