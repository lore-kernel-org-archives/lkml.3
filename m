Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3GYPGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:06:07 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:49960 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3GYPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:06:03 -0400
Date: Thu, 25 Jul 2013 11:05:54 -0400
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
Subject: Re: [PATCH 18/21] x86, numa: Synchronize nid info in
 memblock.reserve with numa_meminfo.
Message-ID: <20130725150554.GC26107@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com>
 <20130723212548.GZ21100@mtj.dyndns.org>
 <51F0A4F9.2060802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0A4F9.2060802@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Thu, Jul 25, 2013 at 12:09:29PM +0800, Tang Chen wrote:
> And as in [patch 14/21], when reserving hotpluggable memory, we use
> pxm. So my

Which is kinda nasty.

> idea was to do a nid sync in numa_init(). After this, memblock will
> set nid when
> it allocates memory.

Sure, that's the only place we can set the numa node IDs but my point
is that you don't need to add another interface.  Jet let
memblock_set_node() handle both memblock.memory and .reserved ranges.
That way, you can make memblock simpler to use and less error-prone.

> If we want to let memblock_set_node() and alloc functions set nid on
> the reserved
> regions, we should setup nid <-> pxm mapping when we parst SRAT for
> the first time.

I don't follow why it has to be different.  Why do you need to do
anything differently?  What am I missing here?

Thanks.

-- 
tejun
