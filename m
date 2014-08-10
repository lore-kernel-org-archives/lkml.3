Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaHJSg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 14:36:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaHJSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 14:36:28 -0400
Date: Sun, 10 Aug 2014 20:36:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Li Yang <leoli@freescale.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ugg_geth: Fix build error in -next
Message-ID: <20140810183622.GC5134@pengutronix.de>
References: <1407687554-14539-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407687554-14539-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guenter,

On Sun, Aug 10, 2014 at 09:19:14AM -0700, Guenter Roeck wrote:
> powerpc:mpc83xx_defconfig and other builds fail with
> 
> drivers/net/ethernet/freescale/ucc_geth.c: In function 'ucc_geth_remove':
> drivers/net/ethernet/freescale/ucc_geth.c:3927:19: error:
> 	'struct ucc_geth_private' has no member named 'info'
>   of_node_put(ugeth->info->tbi_node);
>                      ^
> drivers/net/ethernet/freescale/ucc_geth.c:3928:19: error:
> 	     'struct ucc_geth_private' has no member named 'info'
>   of_node_put(ugeth->info->phy_node);
>   		     ^
> 
> Introduced by commit "net: ucc_geth: drop acquired references in probe error
> path and remove".
> 
> From the context, it appears that the variable is named ug_info.
> 
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Only seen in -next.
My patch was only sent just now, but it has the subject right:

	http://mid.gmane.org/1407695525-32227-1-git-send-email-u.kleine-koenig@pengutronix.de

Another upside is that it contains a Fixes: header.

Other than that my patch is the same. In case davem picks up yours:

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards and thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
