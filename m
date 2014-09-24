Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaIXFZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:25:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:50981 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaIXFZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,586,1406617200"; 
   d="scan'208";a="578015837"
Date: Wed, 24 Sep 2014 10:27:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_dma: fix memory leak in dma_pin_iocvec_pages
Message-ID: <20140924045701.GR24663@intel.com>
References: <87d2bdcask.wl%klamm@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2bdcask.wl%klamm@yandex-team.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:28:59PM +0400, Roman Gushchin wrote:
> dma_pin_iovec_pages() calls get_user_pages() for each iovec. If
> get_user_pages() returns a number smaller than the requested number,
> dma_pin_iovec_pages() calls dma_unpin_iovec_pages(). It releases
> previously allocated iovecs, but pages pinned by last get_user_pages()
> call remain unreleased.
> Fix this by calling put_page() for each such page.
> 
Applied, thanks

-- 
~Vinod
