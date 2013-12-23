Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3LWK0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 05:26:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab3LWK0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 05:26:41 -0500
Date: Mon, 23 Dec 2013 10:26:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Zlatko Calusic <zcalusic@bitsync.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] Configurable fair allocation zone policy v2r6
Message-ID: <20131223102637.GF11295@suse.de>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <52B068B7.4070304@bitsync.net>
 <20131217212327.GL11295@suse.de>
 <52B5BBDF.9010200@bitsync.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52B5BBDF.9010200@bitsync.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 05:03:43PM +0100, Zlatko Calusic wrote:
> On 17.12.2013 22:23, Mel Gorman wrote:
> >On Tue, Dec 17, 2013 at 04:07:35PM +0100, Zlatko Calusic wrote:
> >>On 13.12.2013 15:10, Mel Gorman wrote:
> >>>Kicked this another bit today. It's still a bit half-baked but it restores
> >>>the historical performance and leaves the door open at the end for playing
> >>>nice with distributing file pages between nodes. Finishing this series
> >>>depends on whether we are going to make the remote node behaviour of the
> >>>fair zone allocation policy configurable or redefine MPOL_LOCAL. I'm in
> >>>favour of the configurable option because the default can be redefined and
> >>>tested while giving users a "compat" mode if we discover the new default
> >>>behaviour sucks for some workload.
> >>>
> >>
> >>I'll start a 5-day test of this patchset in a few hours, unless you
> >>can send an updated one in the meantime. I intend to test it on a
> >>rather boring 4GB x86_64 machine that before Johannes' work had lots
> >>of trouble balancing zones. Would you recommend to use the default
> >>settings, i.e. don't mess with tunables at this point?
> >>
> >
> >For me at least I would prefer you tested v3 of the series with the
> >default settings of not interleaving file-backed pages on remote nodes
> >by default. Johannes might request testing with that knob enabled if the
> >machine is NUMA although I doubt it is with 4G of RAM.
> >
> 
> Tested v3 on UMA machine, with default setting. I see no regression,
> no issues whatsoever. From what I understand, this whole series is
> about fixing issues noticed on NUMA, so I wish you good luck with
> that (no such hardware here). Just be extra careful not to disturb
> finally very well balanced MM on more common machines (and
> especially those equipped with 4GB RAM). And once again thank you
> Johannes for your work, you did a great job.
> 
> Tested-by: Zlatko Calusic <zcalusic@bitsync.net>

Thanks for testing. Even though this patch is about NUMA, it preserves
the fair zone allocation policy on UMA that your workload depends upon.

-- 
Mel Gorman
SUSE Labs
