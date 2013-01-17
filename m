Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3AQAil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:38:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:63751 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3AQAik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:38:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,481,1355126400"; 
   d="scan'208";a="274721124"
Date: Wed, 16 Jan 2013 16:38:37 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: xhci: fix incorrect bit test
Message-ID: <20130117003837.GA11383@xanatos>
References: <1357616371-20689-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357616371-20689-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nickolai,

Thanks for catching this.  Don't worry about sending a new patch with
the short description for the commit, I'll fix that when I send it off.

Sarah Sharp

On Mon, Jan 07, 2013 at 10:39:31PM -0500, Nickolai Zeldovich wrote:
> Fix incorrect bit test that originally showed up in
> 4ee823b83bc9851743fab756c76b27d6a1e2472b: use '&' instead of '&&'.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index cbb44b7..06921b6 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1698,7 +1698,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
>  				faked_port_index + 1);
>  		if (slot_id && xhci->devs[slot_id])
>  			xhci_ring_device(xhci, slot_id);
> -		if (bus_state->port_remote_wakeup && (1 << faked_port_index)) {
> +		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
>  			bus_state->port_remote_wakeup &=
>  				~(1 << faked_port_index);
>  			xhci_test_and_clear_bit(xhci, port_array,
> -- 
> 1.7.10.4
> 
