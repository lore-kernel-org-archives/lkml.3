Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbbAMRRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:17:46 -0500
Received: from mail9.tpgi.com.au ([203.12.160.104]:36171 "EHLO
	mail9.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbAMRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:17:44 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Wed, 14 Jan 2015 04:17:26 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
Message-ID: <54B552CD.6070409@paradise.net.nz>
Date: Wed, 14 Jan 2015 04:15:57 +1100
From: Emrys Bayliss <emrys@paradise.net.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
References: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
In-Reply-To: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was supposed to be a v3 patch. Resent.

On 01/14/2015 04:03 AM, Emrys Bayliss wrote:
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

