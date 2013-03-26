Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab3CZSpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:45:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48882 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760142Ab3CZSp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:45:29 -0400
Date: Tue, 26 Mar 2013 14:45:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Prisk <linux@prisktech.co.nz>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: ehci: unlink_empty_async_suspended() only used
 with CONFIG_PM
In-Reply-To: <1364321673-2030-1-git-send-email-linux@prisktech.co.nz>
Message-ID: <Pine.LNX.4.44L0.1303261443550.999-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Tony Prisk wrote:

> Compiling with !CONFIG_PM generates an unused function warning on
> unlink_empty_async_suspended().
> 
> Enclose the function in a #ifdef CONFIG_PM
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> Fixed up the commit message.
>  drivers/usb/host/ehci-q.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
> index 23d1369..3638b28 100644
> --- a/drivers/usb/host/ehci-q.c
> +++ b/drivers/usb/host/ehci-q.c
> @@ -1316,6 +1316,7 @@ static void unlink_empty_async(struct ehci_hcd *ehci)
>  	}
>  }
>  
> +#ifdef CONFIG_PM
>  /* The root hub is suspended; unlink all the async QHs */
>  static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
>  {
> @@ -1328,7 +1329,7 @@ static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
>  	}
>  	start_iaa_cycle(ehci, false);
>  }
> -
> +#endif
>  /* makes sure the async qh will become idle */
>  /* caller must own ehci->lock */

Acked-by: Alan Stern <stern@rowland.harvard.edu>

... except that the blank line before the comment in the hunk above
should be retained, not removed.

