Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3AUS3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:29:25 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:33103 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3AUS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:29:23 -0500
Date: Mon, 21 Jan 2013 13:29:21 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] dma: edma: add device_channel_caps() support
Message-ID: <20130121182921.GF10020@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <1357844826-30746-3-git-send-email-mporter@ti.com>
 <7bca07cce8884261b9828946dff5a076@DFLE72.ent.ti.com>
 <20130120165108.GE21407@beef>
 <bfaa71fba6ed468cbfd2d79604729b77@DFLE72.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfaa71fba6ed468cbfd2d79604729b77@DFLE72.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:16:32AM +0000, Vinod Koul wrote:
> On Sun, Jan 20, 2013 at 11:51:08AM -0500, Matt Porter wrote:
> > The explanation in the cover letter mentions that dmaengine_slave_config() is
> > required to be called prior to dmaengine_get_channel_caps(). If we
> > switch to the alternative API, then that would go away including the
> > dependency on direction.
> Nope you got that wrong!

:) Yes, dropped the ball there, should have been for the api to make
sense as implemented:

1. Allocate a DMA slave channel
2. Set slave and controller specific parameters
2a. [Optionally] Get channel capabilities
3. Get a descriptor for transaction
4. Submit the transaction
5. Issue pending requests and wait for callback notification

FWIW, the implementation example in the davinci mmc client driver shows
proper use as in the correct documentation above.

-Matt
