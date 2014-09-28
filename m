Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaI1Pgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:36:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51828 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaI1Pgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140925161600.GC1638@intel.com>
References: <87d2bdcask.wl%klamm@yandex-team.ru>
	<20140924045701.GR24663@intel.com>
	<CAPcyv4j5O-5n4YxC7qd05e_fniaofjf=8yfnqoehfJNYumZB4w@mail.gmail.com>
	<20140925161600.GC1638@intel.com>
Date: Sun, 28 Sep 2014 08:36:44 -0700
Message-ID: <CAPcyv4hfo6PqFfoCfB3esAn7qQ0Z+oA=35e+re8v7_Y7C5_UCw@mail.gmail.com>
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

On Thu, Sep 25, 2014 at 9:16 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Sep 23, 2014 at 11:27:06PM -0700, Dan Williams wrote:
>> On Tue, Sep 23, 2014 at 9:57 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>> > On Wed, Sep 03, 2014 at 01:28:59PM +0400, Roman Gushchin wrote:
>> >> dma_pin_iovec_pages() calls get_user_pages() for each iovec. If
>> >> get_user_pages() returns a number smaller than the requested number,
>> >> dma_pin_iovec_pages() calls dma_unpin_iovec_pages(). It releases
>> >> previously allocated iovecs, but pages pinned by last get_user_pages()
>> >> call remain unreleased.
>> >> Fix this by calling put_page() for each such page.
>> >>
>> > Applied, thanks
>>
>> Vinod, I have a patch in my queue that completely removes the remnants
>> of NET_DMA.  It's been deprecated for more than a few cycles now
>> without any reports to reinstate it.  Time to push the final removal
>> patch.  I'll rebase it on top of this so it doesn't collide.
>
> Okay, thanks for update. If you wnat I can remove it, so you don't need to
> rebase.
>

Yes, please drop it.  I'm sending the full removal to Linus.  I added
Roman to the Reported-by and cc'd stable.
