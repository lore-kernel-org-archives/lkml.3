Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbALW0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:26:43 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57203 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbbALW0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:26:42 -0500
Date: Mon, 12 Jan 2015 17:26:34 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] mm: vmscan: init reclaim_state in
 do_try_to_free_pages
Message-ID: <20150112222634.GC25609@phnom.home.cmpxchg.org>
References: <880700a513472a8b86fd3100aef674322c66c68e.1421054931.git.vdavydov@parallels.com>
 <20a8ae66cc2b9412b1bf81c0a46f4e8c737aa537.1421054931.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20a8ae66cc2b9412b1bf81c0a46f4e8c737aa537.1421054931.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:30:38PM +0300, Vladimir Davydov wrote:
> All users of do_try_to_free_pages() want to have current->reclaim_state
> set in order to account reclaimed slab pages. So instead of duplicating
> the reclaim_state initialization code in each call site, let's do it
> directly in do_try_to_free_pages().

Couldn't this be contained in shrink_slab() directly?
