Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3J3PZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:25:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3J3PZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:25:15 -0400
Date: Wed, 30 Oct 2013 15:25:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Fix page_group_by_mobility_disabled breakage
Message-ID: <20131030152511.GQ2400@suse.de>
References: <1382724575-8450-1-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1382724575-8450-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 02:09:35PM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently, set_pageblock_migratetype screw up MIGRATE_CMA and
> MIGRATE_ISOLATE if page_group_by_mobility_disabled is true. It
> rewrite the argument to MIGRATE_UNMOVABLE and we lost these attribute.
> 
> The problem was introduced commit 49255c619f (page allocator: move
> check for disabled anti-fragmentation out of fastpath). So, 4 years
> lived issue may mean that nobody uses page_group_by_mobility_disabled.
> 

Nobody uses page_group_by_mobility_disabled with CMA at least.
page_group_by_mobility_disabled only kicks in automatically for small
machines so it's possible the condition is very rarely encountered.

Anyway

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
