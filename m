Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3GIPYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:24:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36347 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751717Ab3GIPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:24:40 -0400
Date: Tue, 9 Jul 2013 11:24:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: EHCI: Fix resume signalling on remote wakeup
In-Reply-To: <1373378630-2126-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307091124050.1077-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Roger Quadros wrote:

> Set the ehci->resuming flag for the port we receive a remote
> wakeup on so that resume signalling can be completed.
> 
> Without this, the root hub timer will not fire again to check
> if the resume was completed and there will be a never-ending wait on
> on the port.
> 
> This effect is only observed if the HUB IRQ IN does not come after we
> have initiated the port resume.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-hub.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 9ab4a4d..ca6289b 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -858,6 +858,7 @@ static int ehci_hub_control (
>  				ehci->reset_done[wIndex] = jiffies
>  						+ msecs_to_jiffies(20);
>  				usb_hcd_start_port_resume(&hcd->self, wIndex);
> +				set_bit(wIndex, &ehci->resuming_ports);
>  				/* check the port again */
>  				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
>  						ehci->reset_done[wIndex]);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

