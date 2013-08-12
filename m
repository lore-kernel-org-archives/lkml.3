Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3HLPqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:46:31 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:42886 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3HLPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:46:28 -0400
Date: Mon, 12 Aug 2013 11:46:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <imtangchen@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, robert.moore@intel.com,
        lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130812154623.GL15892@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130812145016.GI15892@htj.dyndns.org>
 <52090225.6070208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52090225.6070208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 12, 2013 at 11:41:25PM +0800, Tang Chen wrote:
> Then there is no way to tell the users which memory is hotpluggable.
> 
> phys addr is not user friendly. For users, node or memory device is the
> best. The firmware should arrange the hotpluggable ranges well.

I don't follow.  Why can't the kernel export that information to
userland after boot is complete via printk / sysfs / proc / whatever?
The admin can "request" hotplug by boot param and the kernel would try
to honor that and return the result on boot completion.  I don't
understand why that wouldn't work.

> In my opinion, maybe some application layer tools may use SRAT to show
> the users which memory is hotpluggable. I just think both of the kernel
> and the application layer should obey the same rule.

Sure, just let the kernel tell the user which memory node ended up
hotpluggable after booting.

> >* Similar to the point hpa raised.  If this can be made opportunistic,
> >   do we need the strict reordering to discover things earlier?
> >   Shouldn't it be possible to configure memblock to allocate close to
> >   the kernel image until hotplug and numa information is available?
> >   For most sane cases, the memory allocated will be contained in
> >   non-hotpluggable node anyway and in case they aren't hotplug
> >   wouldn't work but the system will boot and function perfectly fine.
> 
> So far as I know, the kernel image and related data can be loaded
> anywhere, above 4GB. I just can't make any assumption.

I don't follow why that would be problematic.  Wouldn't finding out
which node the kernel image is located in and preferring to allocate
from that node before hotplug info is available be enough?

Thanks.

-- 
tejun
