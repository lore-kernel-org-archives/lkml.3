Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3HFV5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:57:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:36344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3HFV5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,828,1367996400"; 
   d="scan'208";a="278589819"
Date: Tue, 6 Aug 2013 14:57:24 -0700
From: Jon Mason <jon.mason@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dan Williams <djbw@fb.com>, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioatdma: Fix compiler warning
Message-ID: <20130806215724.GA28265@jonmason-lab>
References: <1375824963-19884-1-git-send-email-jon.mason@intel.com>
 <1375825955.7303.37.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375825955.7303.37.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:52:35PM +0200, Paul Bolle wrote:
> On Tue, 2013-08-06 at 14:36 -0700, Jon Mason wrote:
> > GCC v4.6.3 complains:
> > drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
> > drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> > drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> > 
> > This is due to the possibility of idx being negative, thus being outside
> > the boulds of the array.  Correct this by making idx an unsigned int.
> > 
> > Signed-off-by: Jon Mason <jon.mason@intel.com>
> 
> I tried to silence these warnings in
> https://lkml.org/lkml/2013/6/17/233 . And again, after some feedback, in
> https://lkml.org/lkml/2013/7/20/137 . Perhaps that second patch is
> queued somewhere. I don't know.

I stupidly didn't check for an existing patch before I sent it out.
Hopefully Dan/Vinod has your last one queued.

Thanks,
Jon

> 
> 
> Paul Bolle
> 
