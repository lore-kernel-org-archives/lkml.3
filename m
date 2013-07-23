Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab3GWVcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:32:23 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:39766 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3GWVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:32:21 -0400
Date: Tue, 23 Jul 2013 17:32:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 14/21] x86, acpi, numa: Reserve hotpluggable memory at
 early time.
Message-ID: <20130723213212.GA21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com>
 <20130723205557.GS21100@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723205557.GS21100@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 04:55:57PM -0400, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:27PM +0800, Tang Chen wrote:
> > +		/*
> > +		 * In such an early time, we don't have nid. We specify pxm
> > +		 * instead of MAX_NUMNODES to prevent memblock merging regions
> > +		 * on different nodes. And later modify pxm to nid when nid is
> > +		 * mapped so that we can arrange ZONE_MOVABLE on different
> > +		 * nodes.
> > +		 */
> > +		memblock_reserve_hotpluggable(base_address, length, pxm);
> 
> This is rather hacky.  Why not just introduce MEMBLOCK_NO_MERGE flag?

Also, if memblock is gonna know about hotplug memory, why not just let
it control its allocation too instead of blocking it by reserving it
from outside?  These are all pretty general memory hotplug logic which
doesn't have much to do with acpi and I think too much is implemented
on the acpi side.

Thanks.

-- 
tejun
