Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3DOWZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:25:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:61717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab3DOWZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,479,1363158000"; 
   d="scan'208";a="318690698"
Date: Mon, 15 Apr 2013 15:24:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: xhci-dbg: Display endpoint number and direction in
 context dump
Message-ID: <20130415222446.GA13515@xanatos>
References: <20130408154152.GB6117@xanatos>
 <1365109384-5333-1-git-send-email-jwerner@chromium.org>
 <1365466705-12847-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365466705-12847-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 05:18:25PM -0700, Julius Werner wrote:
> diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
> index 5f3a7c7..16a8272 100644
> --- a/drivers/usb/host/xhci-dbg.c
> +++ b/drivers/usb/host/xhci-dbg.c
> @@ -503,11 +503,14 @@ static void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
>  	if (last_ep < 31)
>  		last_ep_ctx = last_ep + 1;
>  	for (i = 0; i < last_ep_ctx; ++i) {
> +		unsigned int epaddr = xhci_get_endpoint_address(i);
>  		struct xhci_ep_ctx *ep_ctx = xhci_get_ep_ctx(xhci, ctx, i);
>  		dma_addr_t dma = ctx->dma +
>  			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
>  
> -		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
> +		xhci_dbg(xhci, "Endpoint %02d %s Context (index %02d):\n",

Sorry, one more nitpick.  Can you reword this to be like "Out Endpoint 0x80
Context i" instead of "Endpoint 0x80 OUT Context"?  There are input
contexts and output contexts in xHCI, and I want to imply the endpoint
is either IN or OUT, not the context.

Sarah Sharp
