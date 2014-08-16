Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaHPNFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 09:05:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39825 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaHPNFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:05:00 -0400
Date: Sat, 16 Aug 2014 09:04:56 -0400
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
Message-ID: <20140816130456.GH9305@htj.dyndns.org>
References: <53E8C5AA.5040506@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E8C5AA.5040506@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 09:31:22PM +0800, Xishi Qiu wrote:
> Let memblock skip the hotpluggable memory regions in __next_mem_range(),
> it is used to to prevent memblock from allocating hotpluggable memory 
> for the kernel at early time. The code is the same as __next_mem_range_rev().
> 
> Clear hotpluggable flag before releasing free pages to the buddy allocator.

Please try to explain "why" in addition to "what".  Why do we need to
clear hotpluggable flag in free_low_memory_core_early() in addition to
numa_clear_node_hotplug() in x86 numa.c?  Does this make x86 code
redundant?  If not, why?

-- 
tejun
