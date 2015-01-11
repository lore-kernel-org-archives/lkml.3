Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbbAKQm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:42:26 -0500
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:59614 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750724AbbAKQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:42:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3873:4321:5007:6261:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12731:12737:12740:13019:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smash55_4eef8c0754539
X-Filterd-Recvd-Size: 2456
Message-ID: <1420994540.3690.2.camel@perches.com>
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
From: Joe Perches <joe@perches.com>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2015 08:42:20 -0800
In-Reply-To: <1420993174-24908-1-git-send-email-emrys@paradise.net.nz>
References: <1420993174-24908-1-git-send-email-emrys@paradise.net.nz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 03:19 +1100, Emrys Bayliss wrote:
> This patch fixes the following checkpatch.pl error:
> rxtx.c:588: WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> ---
>  drivers/staging/vt6656/rxtx.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index ea5140a..cc34704 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -553,8 +553,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>  			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>  
>  		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
> -
> -		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>  	} else {
>  		struct vnt_cts *buf = &head->cts_g;
>  		/* Get SignalField,ServiceField,Length */
> @@ -571,11 +569,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>  			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>  
>  		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
> -
> -		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
>  	}
>  
> -	return 0;
> +	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>  }
>  
>  static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,

This is not the same code.
Does this even compile?

For the second block, you've changed
return <foo>_g(...) to <foo>_g_fb(...).



