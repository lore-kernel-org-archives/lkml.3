Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3GZK0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:26:17 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:32905 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3GZK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:26:14 -0400
Date: Fri, 26 Jul 2013 06:26:09 -0400
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
Message-ID: <20130726102609.GB30786@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com>
 <20130723205557.GS21100@mtj.dyndns.org>
 <20130723213212.GA21100@mtj.dyndns.org>
 <51F089C1.4010402@cn.fujitsu.com>
 <20130725151719.GE26107@mtj.dyndns.org>
 <51F1F0E0.7040800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1F0E0.7040800@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:45:36AM +0800, Tang Chen wrote:
> I just don't want to any new variables to store the hotpluggable regions.
> But without a new shared variable, it seems difficult to achieve the goal
> you said below.

Why can't it be done with the .flags field that was added anyway?

> So how about this.
> 1. Introduce a new global list used to store hotpluggable regions.
> 2. On acpi side, find and fulfill the list.
> 3. On memblock side, make the default allocation function stay away from
>    these regions.

I was thinking more along the line of

1. Mark hotpluggable regions with a flag in memblock.
2. On ACPI side, find and mark hotpluggable regions.
3. Make memblock avoid giving out hotpluggable regions for normal
   allocations.

Thanks.

-- 
tejun
