Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936485Ab3DHPmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:42:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:40350 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759673Ab3DHPmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="316032506"
Date: Mon, 8 Apr 2013 08:41:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: xhci-dbg: Display endpoint number and direction in
 context dump
Message-ID: <20130408154152.GB6117@xanatos>
References: <1365109384-5333-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365109384-5333-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:03:04PM -0700, Julius Werner wrote:
> When CONFIG_XHCI_HCD_DEBUGGING is activated, the XHCI driver can dump
> device and input contexts to the console. The endpoint contexts in that
> dump are labeled "Endpoint N Context", where N is DCI - 1... this is
> very confusing, especially for people who are not that familiar with
> the XHCI specification. Let's change this to display the endpoint number
> and direction, which are much more commonly used concepts in USB (and
> map to XHCI DCIs 1-to-1).

Thanks for the patch, I think it's a good idea, however...

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-dbg.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
> index 5f3a7c7..98b1bee 100644
> --- a/drivers/usb/host/xhci-dbg.c
> +++ b/drivers/usb/host/xhci-dbg.c
> @@ -507,7 +507,8 @@ static void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
>  		dma_addr_t dma = ctx->dma +
>  			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
>  
> -		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
> +		xhci_dbg(xhci, "Endpoint %02d %s Context:\n",
> +				DIV_ROUND_UP(i, 2), i % 2 ? "OUT" : "IN");

...could you create two macros in xhci.h to translate the xHCI endpoint
context number to USB formated endpoint numbers, and IN vs. OUT?  I
suspect that there will be other places in the code where you'll want to
print the USB formatted endpoint numbers.  Having macros for later use
would be helpful.

Also, this patch is too late for the 3.10 merge window, so it will
have to wait for 3.11.

Sarah Sharp
