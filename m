Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab3IBMqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:46:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40686 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3IBMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:46:19 -0400
Subject: Re: [PATCH v4 0/6] dma: edma: Support scatter-lists of any length
From: Vinod Koul <vkoul@infradead.org>
To: Joel Fernandes <joelf@ti.com>
Cc: vinod.koul@intel.com, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>, Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Franklin Cooper <fcooper@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1377817545-18015-1-git-send-email-joelf@ti.com>
References: <1377817545-18015-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Sep 2013 17:29:53 +0530
Message-ID: <1378123193.9854.1.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 18:05 -0500, Joel Fernandes wrote:
> The following series adds support to EDMA driver to enable DMA of
> scatter-gather lists of arbitrary length, but still make use of only
> a certain MAX number of slots at a time for a given channel. Thus
> free-ing up the rest of the slots to other slaves/channels.  With this
> there is no need for slave drivers to query the EDMA driver about how
> much is the MAX it can send at a time as done in [1]. Drivers can send
> SG lists of any number of entries to DMA. Reference discussion at [2].
> 
> With this, all the patches for MMC and EDMA related to "sg limits" can be
> dropped.
> 
> Tested omap-aes and omap_hsmmc drivers with different MAX number of slots,
> even just 1. In the case where it is 1, only 1-slot is used to DMA an
> entire scatter list of arbitrary length.
> Since this series touches EDMA private API code also shared with davinci-pcm,
> playback of a 16-bit 44.1KHz audio file with davinci-pcm has been tested.
> 
> Sample test run with 1 vs 16 (MAX number of slots/SG) in omap-aes driver:
> MAX slots = 1:
>  (128 bit key, 8192 byte blocks): 1266 operations in 1 seconds (10371072 bytes)
> MAX slots = 16:
>  (128 bit key, 8192 byte blocks): 1601 operations in 1 seconds (13115392 bytes)
> 
> Note: For the above test, 8K buffer is mapped into SG list of size 2 so
> only 2 slots are required. So beyond size 2, there will not be any noticeable
> performance improvement. But above experiment just shows as proof of concept
> that even using 1 slot is managed by just DMA'ing 1 SG entry at a time.
much better series, thanks

I think i am okay with this, if anyone has objections pls speak up. Also
I need ack on the ARM patch 3/6 before I can carry this.

-- 
Vinod Koul
Intel Corp.

