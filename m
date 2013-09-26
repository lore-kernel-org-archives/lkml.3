Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3IZOxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:53:32 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:35919 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3IZOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:53:31 -0400
Date: Thu, 26 Sep 2013 10:53:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 6/6] mem-hotplug: Introduce movablenode boot option
Message-ID: <20130926145326.GH3482@htj.dyndns.org>
References: <5241D897.1090905@gmail.com>
 <5241DB62.2090300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241DB62.2090300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 02:35:14AM +0800, Zhang Yanfei wrote:
> From: Tang Chen <tangchen@cn.fujitsu.com>
> 
> The hot-Pluggable field in SRAT specifies which memory is hotpluggable.
> As we mentioned before, if hotpluggable memory is used by the kernel,
> it cannot be hot-removed. So memory hotplug users may want to set all
> hotpluggable memory in ZONE_MOVABLE so that the kernel won't use it.
> 
> Memory hotplug users may also set a node as movable node, which has
> ZONE_MOVABLE only, so that the whole node can be hot-removed.
> 
> But the kernel cannot use memory in ZONE_MOVABLE. By doing this, the
> kernel cannot use memory in movable nodes. This will cause NUMA
> performance down. And other users may be unhappy.
> 
> So we need a way to allow users to enable and disable this functionality.
> In this patch, we introduce movablenode boot option to allow users to
> choose to not to consume hotpluggable memory at early boot time and
> later we can set it as ZONE_MOVABLE.
> 
> To achieve this, the movablenode boot option will control the memblock
> allocation direction. That said, after memblock is ready, before SRAT is
> parsed, we should allocate memory near the kernel image as we explained
> in the previous patches. So if movablenode boot option is set, the kernel
> does the following:
> 
> 1. After memblock is ready, make memblock allocate memory bottom up.
> 2. After SRAT is parsed, make memblock behave as default, allocate memory
>    top down.
> 
> Users can specify "movablenode" in kernel commandline to enable this
> functionality. For those who don't use memory hotplug or who don't want
> to lose their NUMA performance, just don't specify anything. The kernel
> will work as before.
> 
> Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

I hope the param description and comment were better.  Not necessarily
longer, but clearer, so it'd be great if you can polish them a bit
more.  Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
