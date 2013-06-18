Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3FRBGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:06:04 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:41774 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3FRBGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:06:02 -0400
Date: Mon, 17 Jun 2013 18:05:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 11/22] x86, mm, numa: Call
 numa_meminfo_cover_memory() checking early
Message-ID: <20130618010548.GU32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:02:58PM +0800, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> In order to seperate parsing numa info procedure into two steps,
> we need to set memblock nid later, as it could change memblock
> array, and possible doube memblock.memory array which will need
> to allocate buffer.
> 
> We do not need to use nid in memblock to find out absent pages.

 because...

And please also explain it in the source code with comment including
why the check has to be done early.

> So we can move that numa_meminfo_cover_memory() early.

Maybe "So, we can use the NUMA-unaware absent_pages_in_range() in
numa_meminfo_cover_memory() and call the function before setting nid's
to memblock."

> Also we could change __absent_pages_in_range() to static and use
> absent_pages_in_range() directly.

"As this removes the last user of __absent_pages_in_range(), this
patch also makes the function static."

Thanks.

-- 
tejun
