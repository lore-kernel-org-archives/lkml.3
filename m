Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3G2GIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:08:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:36388 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3G2GIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,767,1367996400"; 
   d="scan'208";a="274642823"
Date: Mon, 29 Jul 2013 10:59:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
Message-ID: <20130729052930.GC29095@intel.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
 <20130705064549.GD10947@intel.com>
 <CACDNBm1jTTWLi3Prk+s_fk_BxNdzra4fG690sSMrKvwWXVW5oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACDNBm1jTTWLi3Prk+s_fk_BxNdzra4fG690sSMrKvwWXVW5oQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:22:50AM +0800, Xiang Wang wrote:

Btw its generally a good idea to remove the parts not required for further
discussion

> Would you please explain a little more about why we should use
> GFP_NOWAIT here? This memory is not dedicated for DMA controller. Do
> we have special reasons to use GFP_NOWAIT? Thanks!
There are few reasons
- the dma requests can be triggered from atomic context
- so for above you can argue to use the GFP_ATOMIC and the guideline for dma
  drivers [1] was discussed briefly

~Vinod
[1]: http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/02316.html

-- 
