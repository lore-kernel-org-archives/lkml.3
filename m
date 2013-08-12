Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3HLPXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:23:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47087 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3HLPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:23:48 -0400
Date: Mon, 12 Aug 2013 11:23:43 -0400
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, robert.moore@intel.com,
        lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130812152343.GK15892@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130812145016.GI15892@htj.dyndns.org>
 <5208FBBC.2080304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208FBBC.2080304@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 12, 2013 at 08:14:04AM -0700, H. Peter Anvin wrote:
> It gets really messy if it is advisory.  Suddenly you have the user
> thinking they can hotswap a memory bank and they just can't.

I'm very skeptical that not doing the strict re-ordering would
increase the chance of reaching memory allocation where hot unplug
would be impossible by much.  Given that, it'd be much better to be
able to boot w/o hotunplug capability than to fail boot.  The kernel
can whine loudly when hotunplug conditions aren't met but I think that
really is as far as that should go.

> Overall, I'm getting convinced that this whole approach is just doomed
> to failure -- it will not provide the user what they expect and what
> they need, which is to be able to hotswap any particular chunk of
> memory.  This means that there has to be a remapping layer, either using
> the TLBs (perhaps leveraging the Xen machine page number) or using
> things like QPI memory routing.

For hot unplug to work in completely generic manner, yeah, there
probably needs to be an extra layer of indirection.  Have no idea what
the correct way to achieve that would be tho.  I'm also not sure how
practicial memory hot unplug is for physical machines and improving
ballooning could be a better approach for vms.

Thanks.

-- 
tejun
