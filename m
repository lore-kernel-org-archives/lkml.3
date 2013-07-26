Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3GZJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:30:26 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41366 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab3GZJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:30:25 -0400
Date: Fri, 26 Jul 2013 11:30:15 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to
 dma_async_tx_descriptor
Message-ID: <20130726093015.GA2439@breakpoint.cc>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
 <51F13CEB.7030408@metafoo.de>
 <51F1404B.7070207@linutronix.de>
 <51F14513.5030200@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F14513.5030200@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 05:32:35PM +0200, Lars-Peter Clausen wrote:
> > I see. But it can't be reused before calling the callback if it is
> > going to call the callback, right?
> > So if this is a no-no, I'm left with an additional argument to the
> > complete callback?
> 
> Hm, maybe using dmaengine_tx_status() and checking the residue field of the
> state struct. transferred is basically len - residue.

This might actually work. So this would reduce the patch to simply update the
kernel doc for residue in struct dma_tx_state that it might also be valid for
DMA_SUCCESS.

Sebastian
