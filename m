Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaL3FAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:00:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45399 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3FAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:00:45 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 30 Dec 2014 14:00:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: m.szyprowski@samsung.com, mina86@mina86.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, pintu.k@samsung.com,
        weijie.yang@samsung.com, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, vbabka@suse.cz,
        laurent.pinchart+renesas@ideasonboard.com, rientjes@google.com,
        sasha.levin@oracle.com, liuweixing@xiaomi.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, teawater@gmail.com
Subject: Re: [PATCH 3/3] CMA: Add cma_alloc_counter to make cma_alloc work
 better if it meet busy range
Message-ID: <20141230050038.GD4588@js1304-P5Q-DELUXE>
References: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
 <1419500608-11656-4-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419500608-11656-4-git-send-email-zhuhui@xiaomi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 05:43:28PM +0800, Hui Zhu wrote:
> In [1], Joonsoo said that cma_alloc_counter is useless because pageblock
> is isolated.
> But if alloc_contig_range meet a busy range, it will undo_isolate_page_range
> before goto try next range. At this time, __rmqueue_cma can begin allocd
> CMA memory from the range.

Is there any real issue from this?
When failed, we will quickly re-isolate pageblock for adjacent page
so there is no big problem I guess.

If there is real issue, how about doing start_isolation/undo_isolation
in cma_alloc()? It would reduce useless do/undo isolation due to
failed trial.

Thanks.

