Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3A1EdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:33:00 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53038 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3A1Ec7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:32:59 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-4f-5105ff79a6e9
Date: Mon, 28 Jan 2013 13:32:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 6/9] zsmalloc: promote to lib/
Message-ID: <20130128043257.GH3321@blaptop>
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-7-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130128040116.GF3321@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128040116.GF3321@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:01:16PM +0900, Minchan Kim wrote:
> On Mon, Jan 07, 2013 at 02:24:37PM -0600, Seth Jennings wrote:
> > This patch promotes the slab-based zsmalloc memory allocator
> > from the staging tree to lib/
> > 
> > zswap depends on this allocator for storing compressed RAM pages
> > in an efficient way under system wide memory pressure where
> > high-order (greater than 0) page allocation are very likely to
> > fail.
> > 
> > For more information on zsmalloc and its internals, read the
> > documentation at the top of the zsmalloc.c file.
> > 
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> Seth, zsmalloc has a bug[1], I sent a patch totay. If it want't known,
> it mighte be no problem to promote but it's known bug so let's fix it
> before promoting.
> 
> Another question. Why do you promote zsmalloc in this patchset?
> It might make you hard to merge even zswap into staging.

When I look at [8/9], I realized you are trying to merge this patch
into mm/, NOT staging. I don't know history why zsmalloc/zram/zscache was
in staging at the beginning but personally, I don't ojbect zswap into /mm
directly because I got realized staging is very deep hole to get out,
expecially related to mm stuff. ;-)

-- 
Kind regards,
Minchan Kim
