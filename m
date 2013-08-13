Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3HMOjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:39:10 -0400
Received: from mail-gh0-f177.google.com ([209.85.160.177]:57564 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab3HMOjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:39:04 -0400
Date: Tue, 13 Aug 2013 10:38:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tang Chen <imtangchen@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130813143856.GA26596@mtj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130812145016.GI15892@htj.dyndns.org>
 <5208FBBC.2080304@zytor.com>
 <20130812152343.GK15892@htj.dyndns.org>
 <52090D7F.6060600@gmail.com>
 <20130812164650.GN15892@htj.dyndns.org>
 <5209CEC1.8070908@cn.fujitsu.com>
 <520A02DE.1010908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A02DE.1010908@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Tue, Aug 13, 2013 at 05:56:46PM +0800, Tang Chen wrote:
> 1. Introduce a memblock.current_limit_low to limit the lowest address
>    that memblock can use.
> 
> 2. Make memblock be able to allocate memory from low to high.
> 
> 3. Get kernel image address on x86, and set memblock.current_limit_low
>    to it before SRAT is parsed. Then we achieve the goal.
> 
> 4. Reset it to 0, and make memblock allocate memory form high to low.
> 
> How do you think of this, or do you have any better idea ?

Yes, something like that.  Maybe have something like
memblock_set_alloc_range(low, high, low_to_high) in memblock?  Once
NUMA info is available arch code can call memblock_set_alloc_range(0,
0, false) to reset it to the default behavior.

> Thanks for your patient and help. :)

Heh, sorry about all the roundabouts.  Your persistence is much
appreciated. :)

-- 
tejun
