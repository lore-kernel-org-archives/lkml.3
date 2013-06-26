Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3FZXrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:47:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:59413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3FZXrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:47:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,947,1363158000"; 
   d="scan'208";a="356334171"
Date: Wed, 26 Jun 2013 16:47:04 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dmadevices: dma_sync_wait undefined
Message-ID: <20130626234704.GG3344@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
 <1371602813-19828-2-git-send-email-jon.mason@intel.com>
 <CAA9_cmc1Gu=BnM_OpMuqL7Hcjz-kfqxJtZzGHP8Nh-hc+tCWeA@mail.gmail.com>
 <20130619162812.GA20657@jonmason-lab>
 <CAA9_cmehScXsCgxwTHxSJ-KXaa52itDoY+3j1Yajnpy-GFU7Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmehScXsCgxwTHxSJ-KXaa52itDoY+3j1Yajnpy-GFU7Hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:20:30PM -0700, Dan Williams wrote:
> On Wed, Jun 19, 2013 at 9:28 AM, Jon Mason <jon.mason@intel.com> wrote:
> > On Tue, Jun 18, 2013 at 06:13:28PM -0700, Dan Williams wrote:
> [..]
> > NTB is currently using it to flush any pending DMAs.  This is needed
> > to allow the DMA engine and the CPU to perform operations on the same
> > "Memory Window".  Without this, it is possible for the operations to
> > complete out of order, which is not a desired outcome for any network
> > traffic over NTB.  CPU is preferred over DMA engine for small
> > transfers.  Also, it provides an alternative for errors in the DMA
> > engine copy process (e.g., DMA mapping, device_prep_dma_memcpy, and
> > dmaengine_submit).
> 
> Ok there really isn't a better alternative, is NTB always polling or
> does it also use completion callbacks?

It uses the callbacks.  I've change the code to use dma_find_channel,
and will push it for review as a RFC shortly.

Thanks,
Jon
