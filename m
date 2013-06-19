Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3FSS4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:56:41 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43163 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130619175206.GA20737@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
	<1371602813-19828-3-git-send-email-jon.mason@intel.com>
	<CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
	<20130619175206.GA20737@jonmason-lab>
Date: Wed, 19 Jun 2013 11:56:38 -0700
X-Google-Sender-Auth: pUCqtvlwQogDLyhsI24Rf6HesdM
Message-ID: <CAA9_cmdVfFmD5Li4b8WEtAiqCiSCKYuva_86MLV3ysAhyLXtig@mail.gmail.com>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:52 AM, Jon Mason <jon.mason@intel.com> wrote:
>> DMA_PRIVATE here keeps all channels private, so they couldn't be used
>> elsewhere, for example raid offload.  Do you need a private allocation
>> or can you get away with a dynamically assigned channel?
>
> I would like to have a dedicated DMA engine.  async_tx could cause the
> copies to complete out of order.  Do I need to add infrastructure to
> allow for private channel usage, and when unused allow the channel to
> be used by async_tx?

Can NTB just call dma_find_channel() once and be done?  Also, async_tx
will only get things out of order if you allow it to pick a new
channel for every operation, but as long as you specify a dependency
chain it will keep things in order (same as remembering the result of
dma_find_channel).

--
Dan
