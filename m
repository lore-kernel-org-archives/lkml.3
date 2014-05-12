Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaELHIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:08:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:23606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaELHIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="430797797"
Date: Mon, 12 May 2014 10:08:18 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>
Subject: Re: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
Message-ID: <20140512070818.GV3722@lahna.fi.intel.com>
References: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140509103315.GJ12304@sirena.org.uk>
 <20140509112105.GS3722@lahna.fi.intel.com>
 <20140509112712.GL12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509112712.GL12304@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:27:12PM +0100, Mark Brown wrote:
> On Fri, May 09, 2014 at 02:21:05PM +0300, Mika Westerberg wrote:
> > On Fri, May 09, 2014 at 11:33:15AM +0100, Mark Brown wrote:
> 
> > > Is this definitely the case for all of the IPs using this driver?  It
> > > seems like something which might have been present in actual PXA
> > > implemenetations but got fixed in later revisons used with x86.  Equally
> > > well the current code is clearly broken either way so I'm not sure that
> > > problems with older systems should be a barrier to merging the patch but
> > > it seems better to check.
> 
> > This code came with x86 LPSS implementation originally. The PXA one,
> > which lives in a different file (spi-pxa2xx-pxadma.c) didn't have any
> > such checks AFAIK.
> 
> OK, that should be fine then.  The PXA platforms should be being
> converted over to use this file as part of the dmaengine transition on
> that platform so we can't assume it's Intel specific even though it was
> originally written for x86.

Right and it isn't. However, this code (the one I'm removing with this
patch) was developed on early Haswell machines where we encountered this
restriction. With the hardware that is shipping the restriction is gone
so I don't see much point keeping it there.
