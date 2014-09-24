Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaIXG1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:27:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33568 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXG1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140924045701.GR24663@intel.com>
References: <87d2bdcask.wl%klamm@yandex-team.ru>
	<20140924045701.GR24663@intel.com>
Date: Tue, 23 Sep 2014 23:27:06 -0700
Message-ID: <CAPcyv4j5O-5n4YxC7qd05e_fniaofjf=8yfnqoehfJNYumZB4w@mail.gmail.com>
Subject: Re: [PATCH] net_dma: fix memory leak in dma_pin_iocvec_pages
From: Dan Williams <dan.j.williams@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 9:57 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Sep 03, 2014 at 01:28:59PM +0400, Roman Gushchin wrote:
>> dma_pin_iovec_pages() calls get_user_pages() for each iovec. If
>> get_user_pages() returns a number smaller than the requested number,
>> dma_pin_iovec_pages() calls dma_unpin_iovec_pages(). It releases
>> previously allocated iovecs, but pages pinned by last get_user_pages()
>> call remain unreleased.
>> Fix this by calling put_page() for each such page.
>>
> Applied, thanks

Vinod, I have a patch in my queue that completely removes the remnants
of NET_DMA.  It's been deprecated for more than a few cycles now
without any reports to reinstate it.  Time to push the final removal
patch.  I'll rebase it on top of this so it doesn't collide.
