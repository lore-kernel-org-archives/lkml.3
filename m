Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaDHOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:47:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbaDHOrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:47:40 -0400
Date: Tue, 8 Apr 2014 15:47:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: sivanich@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
Message-ID: <20140408144735.GK7292@suse.de>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <1396910068-11637-2-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.10.1404080910040.8782@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404080910040.8782@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:14:05AM -0500, Christoph Lameter wrote:
> On Mon, 7 Apr 2014, Mel Gorman wrote:
> 
> > zone_reclaim_mode causes processes to prefer reclaiming memory from local
> > node instead of spilling over to other nodes. This made sense initially when
> > NUMA machines were almost exclusively HPC and the workload was partitioned
> > into nodes. The NUMA penalties were sufficiently high to justify reclaiming
> > the memory. On current machines and workloads it is often the case that
> > zone_reclaim_mode destroys performance but not all users know how to detect
> > this. Favour the common case and disable it by default. Users that are
> > sophisticated enough to know they need zone_reclaim_mode will detect it.
> 
> Ok that is going to require SGI machines to deal with zone_reclaim
> configurations on bootup. Dimitri? Any comments?
> 

The SGI machines are also likely to be managed by system administrators
who are both aware of zone_reclaim_mode and know how to evaluate if it
should be enabled or not. The pair of patches is really aimmed at the
common case of 2-8 socket machines running workloads that are not NUMA
aware.

-- 
Mel Gorman
SUSE Labs
