Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaDINI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbaDINIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:08:25 -0400
Date: Wed, 9 Apr 2014 14:08:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Josh Berkus <josh@agliodbs.com>
Cc: Robert Haas <robertmhaas@gmail.com>, Christoph Lameter <cl@linux.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, sivanich@sgi.com
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
Message-ID: <20140409130819.GS7292@suse.de>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <5343A494.9070707@suse.cz>
 <alpine.DEB.2.10.1404080914280.8782@nuc>
 <CA+TgmoY=vUdtdnJUEK1h-UcaNoqqLUctt44S8vj2B7EVUXUOyA@mail.gmail.com>
 <WM!55d2a092da9f6180473043487a4eb612ae8195f78d2ffdd83f673ed5cb2cb9659cf61e0c8d5bae23f5c914057bcd2ee4!@asav-3.01.com>
 <53445481.3030202@agliodbs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53445481.3030202@agliodbs.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 03:56:49PM -0400, Josh Berkus wrote:
> On 04/08/2014 03:53 PM, Robert Haas wrote:
> > In an ideal world, the kernel would put the hottest pages on the local
> > node and the less-hot pages on remote nodes, moving pages around as
> > the workload shifts.  In practice, that's probably pretty hard.
> > Fortunately, it's not nearly as important as making sure we don't
> > unnecessarily hit the disk, which is infinitely slower than any memory
> > bank.
> 
> Even if the kernel could do this, we would *still* have to disable it
> for PostgreSQL, since our double-buffering makes our pages look "cold"
> to the kernel ... as discussed.
> 

If it's the shared mapping that is being used then automatic NUMA
balancing should migrate those pages to a node local to the CPU
accessing it but how well it works will partially depend on how much
those accesses move around. It's independent of the zone_reclaim_mode
issue.

-- 
Mel Gorman
SUSE Labs
