Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbaJ3BGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:06:21 -0400
Received: from hydra.tuxags.com ([64.13.172.54]:49772 "EHLO mail.tuxags.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618AbaJ3BGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:06:19 -0400
Date: Wed, 29 Oct 2014 18:06:19 -0700
From: Matt Mullins <mmullins@mmlx.us>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matt Mullins <mmullins@mmlx.us>, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/balloon_compaction: fix deflation when compaction
 is disabled
Message-ID: <20141030010618.GE29098@hydra.tuxags.com>
Mail-Followup-To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matt Mullins <mmullins@mmlx.us>, linux-kernel@vger.kernel.org,
	Rafael Aquini <aquini@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>, stable@vger.kernel.org
References: <20141028202333.GC29098@hydra.tuxags.com>
 <20141029115107.23071.26065.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029115107.23071.26065.stgit@buzz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:51:07PM +0400, Konstantin Khlebnikov wrote:
> Fix for commit d6d86c0a7f8ddc5b38cf089222cb1d9540762dc2
> ("mm/balloon_compaction: redesign ballooned pages management").
> 
> If CONFIG_BALLOON_COMPACTION=n balloon_page_insert() does not link
> pages with balloon and doesn't set PagePrivate flag, as a result
> balloon_page_dequeue cannot get any pages because it thinks that
> all of them are isolated. Without balloon compaction nobody can
> isolate ballooned pages, it's safe to remove this check.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Reported-by: Matt Mullins <mmullins@mmlx.us>
> Cc: Stable <stable@vger.kernel.org>	(v3.17)

That seems to do it, thanks!

Tested-by: Matt Mullins <mmullins@mmlx.us>
