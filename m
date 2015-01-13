Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbbAMROc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:14:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAMROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:14:31 -0500
Date: Tue, 13 Jan 2015 09:14:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113171429.GC12822@kroah.com>
References: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:03:24AM +1100, Emrys Bayliss wrote:
> This patch fixes the following checkpatch.pl error:
> rxtx.c:558: WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> ---
> The else statement was replaced with a block to avoid the following
> compiler error:
> "warning: ISO C90 forbids mixed declarations and code"
> due to this declaration:
> struct vnt_cts *buf = &head->cts_g; (line 559)
> 
> Is there a better way such as using head (a union) directly instead?
> 
> The last patch I sent removed the return 0. Since this isn't related to
> the error in the title I left it for a separate patch.
> 
>  drivers/staging/vt6656/rxtx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index ea5140a..831a051 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -555,7 +555,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>  		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
>  
>  		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
> -	} else {
> +	}
> +
> +	{
>  		struct vnt_cts *buf = &head->cts_g;
>  		/* Get SignalField,ServiceField,Length */
>  		vnt_get_phy_field(priv, cts_frame_len,

This doesn't look correct at all, please fix up properly.

greg k-h
