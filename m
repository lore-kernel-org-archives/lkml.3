Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3A1X6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:58:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44252 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3A1X6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:58:06 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-05-5107108c6442
Date: Tue, 29 Jan 2013 08:58:04 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv3 3/6] mm: break up swap_writepage() for frontswap
 backends
Message-ID: <20130128235804.GF4752@blaptop>
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1359409767-30092-4-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359409767-30092-4-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:49:24PM -0600, Seth Jennings wrote:
> swap_writepage() is currently where frontswap hooks into the swap
> write path to capture pages with the frontswap_store() function.
> However, if a frontswap backend wants to "resume" the writeback of
> a page to the swap device, it can't call swap_writepage() as
> the page will simply reenter the backend.
> 
> This patch separates swap_writepage() into a top and bottom half, the
> bottom half named __swap_writepage() to allow a frontswap backend,
> like zswap, to resume writeback beyond the frontswap_store() hook.
> 
> __add_to_swap_cache() is also made non-static so that the page for
> which writeback is to be resumed can be added to the swap cache.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
