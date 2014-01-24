Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaAXLJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:09:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaAXLJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:09:32 -0500
Date: Fri, 24 Jan 2014 11:09:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Message-ID: <20140124110928.GR4963@suse.de>
References: <20131220093022.GV11295@suse.de>
 <52DF353D.6050300@redhat.com>
 <20140122093435.GS4963@suse.de>
 <alpine.DEB.2.10.1401231436300.8031@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401231436300.8031@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:47:10PM -0600, Christoph Lameter wrote:
> On Wed, 22 Jan 2014, Mel Gorman wrote:
> 
> > Large block support was proposed years ago by Christoph Lameter
> > (http://lwn.net/Articles/232757/). I think I was just getting started
> > in the community at the time so I do not recall any of the details. I do
> > believe it motivated an alternative by Nick Piggin called fsblock though
> > (http://lwn.net/Articles/321390/). At the very least it would be nice to
> > know why neither were never merged for those of us that were not around
> > at the time and who may not have the chance to dive through mailing list
> > archives between now and March.
> 
> It was rejected first because of the necessity of higher order page
> allocations. Nick and I then added ways to virtually map higher order
> pages if the page allocator could no longe provide those.
> 

That'd be okish for 64-bit at least although it would show up as
degraded performance in some cases when virtually contiguous buffers were
used. Aside from the higher setup, access costs and teardown costs of a
virtual contiguous buffer, the underlying storage would no longer gets
a single buffer as part of the IO request. Would that not offset many of
the advantages?

-- 
Mel Gorman
SUSE Labs
