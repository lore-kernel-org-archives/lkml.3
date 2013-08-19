Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3HSKA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:00:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:1981 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3HSKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,912,1367996400"; 
   d="scan'208";a="348289269"
Date: Mon, 19 Aug 2013 14:47:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
Message-ID: <20130819091730.GB5810@intel.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
 <20130705064549.GD10947@intel.com>
 <CACDNBm1jTTWLi3Prk+s_fk_BxNdzra4fG690sSMrKvwWXVW5oQ@mail.gmail.com>
 <20130729052930.GC29095@intel.com>
 <CACDNBm03v0KB_2XhUzKmi7c9BpfG1tSOUUNa549ETs=3FbZAvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACDNBm03v0KB_2XhUzKmi7c9BpfG1tSOUUNa549ETs=3FbZAvA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:27:47AM +0800, Xiang Wang wrote:
> 2013/7/29 Vinod Koul <vinod.koul@intel.com>:
> > On Thu, Jul 25, 2013 at 10:22:50AM +0800, Xiang Wang wrote:
> >
> > Btw its generally a good idea to remove the parts not required for further
> > discussion
> >
> >> Would you please explain a little more about why we should use
> >> GFP_NOWAIT here? This memory is not dedicated for DMA controller. Do
> >> we have special reasons to use GFP_NOWAIT? Thanks!
> > There are few reasons
> > - the dma requests can be triggered from atomic context
> > - so for above you can argue to use the GFP_ATOMIC and the guideline for dma
> >   drivers [1] was discussed briefly
> >
> > ~Vinod
> > [1]: http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/02316.html
> >
> > --
> Hi, Vinod
> Thanks for your explanation. But want to double confirm with you that
> the memory alloc in my patch is in probe function, still need to use
> GFP_NOWAIT? Thanks!
Yes I would recommend it

~Vinod
