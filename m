Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbbAMGBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:01:36 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38556 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbAMGBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:01:34 -0500
Message-ID: <1421128891.4099.15.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2] gianfar: correct the bad expression while writing
 bit-pattern
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: davem@davemloft.net, claudiu.manoil@freescale.com, peter.senna@gmail.com,
        shemminger@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 22:01:31 -0800
In-Reply-To: <1421126938-16268-1-git-send-email-sanjeev_sharma@mentor.com>
References: <54B3D63B.1010608@cogentembedded.com>
	 <1421126938-16268-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 10:58 +0530, Sanjeev Sharma wrote:
> This patch correct the bad expression while writing the
> bit-pattern from software's buffer to hardware registers.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
> Changes in v2:
>   - incorporated review comment as per Sergei. 
> 
>  drivers/net/ethernet/freescale/gianfar_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> index 3e1a9c1..347d5ee 100644
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> @@ -1586,7 +1586,7 @@ static int gfar_write_filer_table(struct gfar_private *priv,
>  		return -EBUSY;
>  
>  	/* Fill regular entries */
> -	for (; i < MAX_FILER_IDX - 1 && (tab->fe[i].ctrl | tab->fe[i].ctrl);
> +	for (; i < MAX_FILER_IDX - 1 && i < tab->fe[i].ctrl);
>  	     i++)
>  		gfar_write_filer(priv, i, tab->fe[i].ctrl, tab->fe[i].prop);
>  	/* Fill the rest with fall-troughs */

This makes no sense. Have you tried to compile this ?


