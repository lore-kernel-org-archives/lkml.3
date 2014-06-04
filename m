Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaFDLES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:04:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbaFDLER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:04:17 -0400
Date: Wed, 4 Jun 2014 12:04:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [patch -mm 3/3] mm, compaction: avoid compacting memory for thp
 if pageblock cannot become free
Message-ID: <20140604110411.GK10819@suse.de>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
 <1400233673-11477-1-git-send-email-vbabka@suse.cz>
 <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com>
 <537DB0E5.40602@suse.cz>
 <alpine.DEB.2.02.1405220127320.13630@chino.kir.corp.google.com>
 <537DE799.3040400@suse.cz>
 <alpine.DEB.2.02.1406031728390.5312@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1406031729410.5312@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406031729410.5312@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 05:30:01PM -0700, David Rientjes wrote:
> It's pointless to migrate pages within a pageblock if the entire pageblock will 
> not become free for a thp allocation.
> 
> If we encounter a page that cannot be migrated and a direct compactor other than 
> khugepaged is trying to allocate a hugepage for thp, then skip the entire 
> pageblock and avoid migrating pages needlessly.
> 

It's not completely pointless. A movable page may be placed within an
unmovable pageblock due to insufficient free memory or a pageblock changed
type. When this happens then partial migration moves the movable page
of out of the unmovable block. Future unmovable allocations can then be
placed with other unmovable pages instead of falling back to other blocks
and degrading fragmentation over time.

-- 
Mel Gorman
SUSE Labs
