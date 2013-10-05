Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3JEMKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 08:10:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:51633 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab3JEMKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 08:10:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Simon Easter <simon.easter@gmail.com>
Subject: Re: [PATCH 1/1] Fix SD card detection and use correct transfer interval.
Date: Sat, 5 Oct 2013 12:06:10 +0000 (UTC)
Message-ID: <loom.20131005T140209-999@post.gmane.org>
References: <1370103731-5667-1-git-send-email-marcus.overhagen@gmail.com> <1370103731-5667-2-git-send-email-marcus.overhagen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 79.148.28.163 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Overhagen <marcus.overhagen <at> gmail.com> writes:

> 
> Increasing the timeout when polling for card status to 100ms
> as used at other places in this driver fixes SD card detection.
> 
> Also use correct interval when doing the interrupt transfer,
> this fixes the "xhci_queue_intr_tx: 74 callbacks suppressed"
> spamming to syslog that was occuring when this driver is used.
> 
> Signed-off-by: Marcus Overhagen <marcus.overhagen <at> gmail.com>
> ---
>  drivers/staging/rts5139/rts51x_transport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rts5139/rts51x_transport.c 
b/drivers/staging/rts5139/rts51x_transport.c
> index 89e4d80..c172f4a 100644
> --- a/drivers/staging/rts5139/rts51x_transport.c
> +++ b/drivers/staging/rts5139/rts51x_transport.c
>  <at>  <at>  -635,12 +635,12  <at>  <at>  int rts51x_get_epc_status(struct 
rts51x_chip *chip, u16 *status)
>  	ep = chip->usb->pusb_dev->ep_in[usb_pipeendpoint(pipe)];
> 
>  	/* fill and submit the URB */
> -	/* We set interval to 1 here, so the polling interval is controlled
> -	 * by our polling thread */
> +	/* Set interval to 10 here to match the endpoint descriptor,
> +	 * the polling interval is controlled by the polling thread */
>  	usb_fill_int_urb(chip->usb->intr_urb, chip->usb->pusb_dev, pipe,
> -			 status, 2, urb_done_completion, &urb_done, 1);
> +			 status, 2, urb_done_completion, &urb_done, 10);
> 
> -	result = rts51x_msg_common(chip, chip->usb->intr_urb, 50);
> +	result = rts51x_msg_common(chip, chip->usb->intr_urb, 100);
> 
>  	return interpret_urb_result(chip, pipe, 2, result,
>  				    chip->usb->intr_urb->actual_length);


Hi Marcus, 
 I'm trying to apply this patch to 3.8.0-18 kernel tree but looks like it 
doesn't want to take (Ubuntu 13.04 stock) 

I don't suppose you have a patch for this version?, not quite sure if 
reading 
the patch file properly but assuming I get changes in what is the  correct 
way to just compile this module and insert into running config?

Thanks

Simon


