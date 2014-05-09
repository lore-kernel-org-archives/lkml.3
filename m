Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaEILVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:21:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:42610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbaEILVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:21:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1017,1389772800"; 
   d="scan'208";a="529089713"
Date: Fri, 9 May 2014 14:21:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>
Subject: Re: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
Message-ID: <20140509112105.GS3722@lahna.fi.intel.com>
References: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140509103315.GJ12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509103315.GJ12304@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 11:33:15AM +0100, Mark Brown wrote:
> On Thu, May 08, 2014 at 05:30:31PM +0300, Mika Westerberg wrote:
> > In case we are doing DMA transfer and the size of the buffer is not multiple
> > of 4 bytes the driver truncates that to 4-byte boundary and tries to handle
> > remaining bytes using PIO.
> 
> ...
> 
> > While investigating this it turned out that the DMA hardware doesn't even
> > have such limitation so we can solve this by dropping the code that tries
> > to handle unaligned bytes.
> 
> Is this definitely the case for all of the IPs using this driver?  It
> seems like something which might have been present in actual PXA
> implemenetations but got fixed in later revisons used with x86.  Equally
> well the current code is clearly broken either way so I'm not sure that
> problems with older systems should be a barrier to merging the patch but
> it seems better to check.

This code came with x86 LPSS implementation originally. The PXA one,
which lives in a different file (spi-pxa2xx-pxadma.c) didn't have any
such checks AFAIK.
