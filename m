Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbaAWUrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:47:19 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:50426 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbaAWUrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:47:13 -0500
Date: Thu, 23 Jan 2014 14:47:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mel Gorman <mgorman@suse.de>
cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
In-Reply-To: <20140122093435.GS4963@suse.de>
Message-ID: <alpine.DEB.2.10.1401231436300.8031@nuc>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122093435.GS4963@suse.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Mel Gorman wrote:

> Large block support was proposed years ago by Christoph Lameter
> (http://lwn.net/Articles/232757/). I think I was just getting started
> in the community at the time so I do not recall any of the details. I do
> believe it motivated an alternative by Nick Piggin called fsblock though
> (http://lwn.net/Articles/321390/). At the very least it would be nice to
> know why neither were never merged for those of us that were not around
> at the time and who may not have the chance to dive through mailing list
> archives between now and March.

It was rejected first because of the necessity of higher order page
allocations. Nick and I then added ways to virtually map higher order
pages if the page allocator could no longe provide those.

All of this required changes to the basic page cache operations. I added a
way for the mapping to indicate an order for an address range and then
modified the page cache operations to be able to operate on any order
pages.

The patchset that introduced the ability to specify different orders for
the pagecache address ranges was not accepted by Andrew because he thought
there was no chance for the rest of the modifications to become
acceptable.

