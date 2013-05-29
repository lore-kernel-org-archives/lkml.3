Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965867Ab3E2LY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:24:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525Ab3E2LY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:24:26 -0400
Date: Wed, 29 May 2013 13:24:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 2/2 V3] perf/x86/amd: AMD IOMMU PC PERF uncore PMU
 implementation
Message-ID: <20130529112418.GI12193@twins.programming.kicks-ass.net>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1368819813-6481-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20130528121850.GC2575@8bytes.org>
 <51A4E6A8.7080004@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A4E6A8.7080004@amd.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:17:28PM -0500, Suravee Suthikulanit wrote:
> On 5/28/2013 7:18 AM, Joerg Roedel wrote:

> >That implementation is very basic. Any reason for not using the event
> >reporting mechanism of the IOMMU? You could implement a nice perf
> >iommutop or something to see which devices do the most transactions or
> >something like that.

> This patch is adding perf system-wide counting mode support which is used by
> "perf stat" tool.  We are not implementing the sampling mode since MSI
> interrupt of the IOMMU cannot be used for current perf sampling tools (e.g.
> perf record or top) since the IOMMU counters are not core-specific.   The
> current "perf record" and "perf top" needs to attribute each sample to a
> particular core/pid which would allow the tools to figure out the
> instruction pointer and map the sample to a paticular module.
> 
> If I understand correctly, when you mentioned "perf iommutop", you want a
> new perf user-space tool which will show real-time IOMMU events per IOMMU HW
> and/or device?

Right, unless there's more to the IOMMU event reporting than setting an
event threshold to get an interrupt of kinds I don't see how an
interrupt would be useful except for making sure we don't loose a
counter overflow.

Note that for Intel uncore we poll with a software timer to ensure we
don't miss the overflow because its interrupt facility is either broken
or missing.

If otoh the event reporting thing includes more data than just 'hey
counter overflow!' it might be useful. Not exactly sure how yet because
it would be the first PMU to need this.
