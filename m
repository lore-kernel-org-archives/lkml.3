Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab3GWVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:25:56 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:39981 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab3GWVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:25:54 -0400
Date: Tue, 23 Jul 2013 17:25:48 -0400
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
Message-ID: <20130723212548.GZ21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:59:31PM +0800, Tang Chen wrote:
> Vasilis Liaskovitis found that before we parse SRAT and fulfill numa_meminfo,
> the nids of all the regions in memblock.reserve[] are MAX_NUMNODES. That is
> because nids have not been mapped at that time.
> 
> When we arrange ZONE_MOVABLE in each node later, we need nid in memblock. So
> after we parse SRAT and fulfill nume_meminfo, synchronize the nid info to
> memblock.reserve[] immediately.

Having a separate sync is rather nasty.  Why not let
memblock_set_node() and alloc functions set nid on the reserved
regions?

Thanks.

-- 
tejun
