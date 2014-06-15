Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaFOWCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 18:02:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48272 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752307AbaFOWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 18:02:24 -0400
Date: Sun, 15 Jun 2014 18:02:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
In-Reply-To: <1816dd87707535b6442e5c75fde9f799821c457a.1402863905.git.joe@perches.com>
Message-ID: <Pine.LNX.4.44L0.1406151801421.30784-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Joe Perches wrote:

> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

...

> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> index 27f35e8..681fc5e 100644
> --- a/drivers/usb/host/uhci-hcd.c
> +++ b/drivers/usb/host/uhci-hcd.c
> @@ -589,15 +589,14 @@ static int uhci_start(struct usb_hcd *hcd)
>  	uhci->dentry = dentry;
>  #endif
>  
> -	uhci->frame = dma_alloc_coherent(uhci_dev(uhci),
> -			UHCI_NUMFRAMES * sizeof(*uhci->frame),
> -			&uhci->frame_dma_handle, 0);
> +	uhci->frame = dma_zalloc_coherent(uhci_dev(uhci),
> +					  UHCI_NUMFRAMES * sizeof(*uhci->frame),
> +					  &uhci->frame_dma_handle, 0);

Please don't change the coding style.  This file indents continuation  
lines by two tab stops; it doesn't align things with opening parens.

Alan Stern

