Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbaDWTWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:22:32 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22892 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbaDWTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:22:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,913,1389772800"; 
   d="scan'208";a="25962339"
Date: Wed, 23 Apr 2014 12:22:28 -0700
From: Zi Shen Lim <zlim@broadcom.com>
To: Mark Brown <broonie@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: topology: add MPIDR-based detection
Message-ID: <20140423192228.GA21142@lc-sj1-5012.sj.broadcom.com>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com> <1398217214-12204-3-git-send-email-zlim@broadcom.com> <20140423103648.GM12304@sirena.org.uk> <20140423172720.GA18588@lc-sj1-5012.sj.broadcom.com> <20140423182611.GF12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140423182611.GF12304@sirena.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:26:11PM +0100, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 10:27:20AM -0700, Zi Shen Lim wrote:
> 
> It will at least ensure that all clusters get assigned a unique ID and
> we don't end up discarding some of the information and coming out with
> two identically numbered clusters which then have identically numbered
> CPUs inside of them which doesn't seem clever.

I agree with you. Simply ignoring aff3 is not acceptable, whether or not
someone is using it.

> 
> When I was looking at this it wasn't sufficiently clear to me that the
> cluster clustering would be well modelled by sockets as the scheduler
> currently assumes them, nor what to do with additional levels of that
> (the DT binding allows for infinite levels).  Punting and just putting
> all clusters at the same level avoids active bugs and seems fairly
> conservative.
> 

Sounds like you prefer "cluster of clusters" over "socket", correct?

In any case, with only 4 affinity levels defined in the arch, as long as
we also have 4 variables to capture that information, we should be good,
right?

Anything more exotic not expressable by these 4 affinity levels in MPIDR
will require additional information from other sources such as DT or ACPI.

> > Perhaps we should just add a new 'socket_id' and that will accommodate
> > all cases (up to aff3).
> 
> Not in the non-MT case where we've got two levels above the cluster ID
> in affinity level 1 unless we just combine 2 and 3 (which would be
> reasonable enough of course).

Is the following an accurate description of your proposal for non-MT?

	thread_id   = -1
	core_id     = aff0
	cluster_id  = aff1
	clusters_id = combine(aff2,aff3)

