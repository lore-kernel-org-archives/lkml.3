Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab3E2JPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:15:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965201Ab3E2JPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:15:37 -0400
Date: Wed, 29 May 2013 10:15:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Shaohua Li <shli@kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: mmotm-2013-05-22: Bad page state
Message-ID: <20130529091530.GA29426@suse.de>
References: <51A526D9.3020803@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51A526D9.3020803@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:51:21PM -0700, Dave Hansen wrote:
> I was rebasing my mapping->radix_tree lock batching patches on top of
> Mel's stuff.  It looks like something is jumping the gun and freeing a
> page before it has been written out.  Somebody probably did an extra
> put_page() or something.
> 
> I'm running 3.10.0-rc2-mm1-00322-g8d4c612 from
> 
> 	git://git.cmpxchg.org/linux-mmotm.git
> 
> This is pretty reproducible.  I'll go try and test plain 3.10-rc2 next
> to make sure it's not coming from Linus's stuff.
> 

Patch 1 from the follow-up series "mm: vmscan: Block kswapd if it is
encountering pages under writeback -fix"

The rest of that follow-up series needs further work and I'm still
working on it but patch 1 is what fixes this particular problem.
Changelog says why.

-- 
Mel Gorman
SUSE Labs
