Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbaDHORJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:17:09 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:44057
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869AbaDHORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:17:07 -0400
Date: Tue, 8 Apr 2014 09:17:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vlastimil Babka <vbabka@suse.cz>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, sivanich@sgi.com
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
In-Reply-To: <5343A494.9070707@suse.cz>
Message-ID: <alpine.DEB.2.10.1404080914280.8782@nuc>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <5343A494.9070707@suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014, Vlastimil Babka wrote:

> On 04/08/2014 12:34 AM, Mel Gorman wrote:
> > When it was introduced, zone_reclaim_mode made sense as NUMA distances
> > punished and workloads were generally partitioned to fit into a NUMA
> > node. NUMA machines are now common but few of the workloads are NUMA-aware
> > and it's routine to see major performance due to zone_reclaim_mode being
> > disabled but relatively few can identify the problem.
>     ^ I think you meant "enabled" here?
>
> Just in case the cover letter goes to the changelog...

Correct.

Another solution here would be to increase the threshhold so that
4 socket machines do not enable zone reclaim by default. The larger the
NUMA system is the more memory is off node from the perspective of a
processor and the larger the hit from remote memory.

On the other hand: The more expensive we make reclaim the less it
makes sense to allow zone reclaim to occur.

