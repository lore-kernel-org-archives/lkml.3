Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaL3Es3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:48:29 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45757 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaL3Es2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:48:28 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 30 Dec 2014 13:48:27 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: m.szyprowski@samsung.com, mina86@mina86.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, pintu.k@samsung.com,
        weijie.yang@samsung.com, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, vbabka@suse.cz,
        laurent.pinchart+renesas@ideasonboard.com, rientjes@google.com,
        sasha.levin@oracle.com, liuweixing@xiaomi.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, teawater@gmail.com
Subject: Re: [PATCH 1/3] CMA: Fix the bug that CMA's page number is
 substructed twice
Message-ID: <20141230044826.GC4588@js1304-P5Q-DELUXE>
References: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
 <1419500608-11656-2-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419500608-11656-2-git-send-email-zhuhui@xiaomi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 05:43:26PM +0800, Hui Zhu wrote:
> In Joonsoo's CMA patch "CMA: always treat free cma pages as non-free on
> watermark checking" [1], it changes __zone_watermark_ok to substruct CMA
> pages number from free_pages if system use CMA:
> 	if (IS_ENABLED(CONFIG_CMA) && z->managed_cma_pages)
> 		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);

Hello, 

In fact, without that patch, watermark checking has a problem in current kernel.
If there is reserved CMA region, watermark check for high order
allocation is done loosly. See following thread.

https://lkml.org/lkml/2014/5/30/320

Your patch can fix this situation, so, how about submitting this patch
separately?

Thanks.

