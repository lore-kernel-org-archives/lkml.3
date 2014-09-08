Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaIHGmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:42:43 -0400
Received: from sym2.noone.org ([178.63.92.236]:58495 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaIHGmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:42:42 -0400
Date: Mon, 8 Sep 2014 08:42:40 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: anicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: ozwpan: fix redundant else after break or
 return
Message-ID: <20140908064240.GC3578@distanz.ch>
References: <20140907182403.GB2312@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907182403.GB2312@uwaterloo.ca>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your From: line does not contain a real name and does not match your
Signed-off-by line, please check your e-mail client settings.

On 2014-09-07 at 20:24:03 +0200, anicoara <anicoara@uwaterloo.ca> wrote:
> Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>

No changelog text? Please add a short notice, describing why this change
is done.

> ---
> Patch submitted as part of the Eudyptula challenge.
> 
>  drivers/staging/ozwpan/ozhcd.c |  8 +++-----
>  drivers/staging/ozwpan/ozpd.c  | 10 ++++------
>  2 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index b30c4d87..ba2168f 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -1010,10 +1010,9 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
>  			urb->actual_length = copy_len;
>  			oz_complete_urb(port->ozhcd->hcd, urb, 0);
>  			return;
> -		} else {
> -			oz_dbg(ON, "buffering frame as URB is not available\n");
> -			oz_hcd_buffer_data(ep, data, data_len);
>  		}
> +		oz_dbg(ON, "buffering frame as URB is not available\n");
> +		oz_hcd_buffer_data(ep, data, data_len);
>  		break;
>  	case USB_ENDPOINT_XFER_ISOC:
>  		oz_hcd_buffer_data(ep, data, data_len);
> @@ -1903,8 +1902,7 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
>  	spin_unlock_bh(&ozhcd->hcd_lock);
>  	if (buf[0] != 0 || buf[1] != 0)
>  		return 2;
> -	else
> -		return 0;
> +	return 0;
>  }
> 
>  /*
> diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
> index 26c1049..852c288 100644
> --- a/drivers/staging/ozwpan/ozpd.c
> +++ b/drivers/staging/ozwpan/ozpd.c
> @@ -496,11 +496,10 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
>  			oz_dbg(TX_FRAMES, "Sending ISOC Frame, nb_isoc= %d\n",
>  			       pd->nb_queued_isoc_frames);
>  			return 0;
> -		} else {
> -			kfree_skb(skb);
> -			oz_dbg(TX_FRAMES, "Dropping ISOC Frame>\n");
> -			return -1;
>  		}
> +		kfree_skb(skb);
> +		oz_dbg(TX_FRAMES, "Dropping ISOC Frame>\n");
> +		return -1;
>  	}
> 
>  	pd->last_sent_frame = e;
> @@ -813,8 +812,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
>  			atomic_inc(&g_submitted_isoc);
>  			if (dev_queue_xmit(skb) < 0)
>  				return -1;
> -			else
> -				return 0;
> +			return 0;
>  		}
> 
>  out:	kfree_skb(skb);
> --
> 2.0.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
