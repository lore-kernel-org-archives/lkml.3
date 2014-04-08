Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbaDHOOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:14:10 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:44639
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbaDHOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:14:09 -0400
Date: Tue, 8 Apr 2014 09:14:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: sivanich@sgi.com
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
In-Reply-To: <1396910068-11637-2-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.10.1404080910040.8782@nuc>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <1396910068-11637-2-git-send-email-mgorman@suse.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014, Mel Gorman wrote:

> zone_reclaim_mode causes processes to prefer reclaiming memory from local
> node instead of spilling over to other nodes. This made sense initially when
> NUMA machines were almost exclusively HPC and the workload was partitioned
> into nodes. The NUMA penalties were sufficiently high to justify reclaiming
> the memory. On current machines and workloads it is often the case that
> zone_reclaim_mode destroys performance but not all users know how to detect
> this. Favour the common case and disable it by default. Users that are
> sophisticated enough to know they need zone_reclaim_mode will detect it.

Ok that is going to require SGI machines to deal with zone_reclaim
configurations on bootup. Dimitri? Any comments?

