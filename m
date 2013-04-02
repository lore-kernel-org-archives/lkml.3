Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128Ab3DBIXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:23:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56277 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761108Ab3DBIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130331210605.GA29191@amd.pavel.ucw.cz>
References: <20130331210605.GA29191@amd.pavel.ucw.cz>
Date: Tue, 2 Apr 2013 16:23:13 +0800
Message-ID: <CAHrpEqSVUc1yedCoyOrRoxkjY7=N_pCDB1F7-WvRaP+4UEY68A@mail.gmail.com>
Subject: Re: Freescale FEC: fall back to random address
From: Frank Li <lznuaa@gmail.com>
To: Pavel Machek <pavel@denx.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, fabio.estevam@freescale.com,
        l.stach@pengutronix.de, Frank.Li@freescale.com, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it is okay.

2013/4/1 Pavel Machek <pavel@denx.de>:
> If there's no valid ethernet address, fall back to randomly generated
> one.
>
> (Yes, I need to get newer u-boot for the board, but as the only
> available one is from 2009... this might be good idea).
>
> Signed-off-by: Pavel Machek <pavel@denx.de>
>
>
> index e3f3937..5a7d1e1 100644
> pp--- a/drivers/net/ethernet/freescale/fec.c
> +++ b/drivers/net/ethernet/freescale/fec.c
> @@ -906,6 +914,16 @@ static void fec_get_mac(struct net_device *ndev)
>                 iap = &tmpaddr[0];
>         }
>
> +       /*
> +        * 5) random mac address
> +        */
> +       if (!is_valid_ether_addr(iap)) {
> +               /* Report it and use a random ethernet address instead */
> +               netdev_err(ndev, "Invalid MAC address: %pM\n", iap);
> +               random_ether_addr(iap);
> +               netdev_info(ndev, "Using random MAC address: %pM\n", iap);
> +       }
> +
>         memcpy(ndev->dev_addr, iap, ETH_ALEN);
>
>         /* Adjust MAC if using macaddr */
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
