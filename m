Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423476Ab3FURZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:25:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38870 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423122Ab3FURZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:25:09 -0400
Message-ID: <1371835508.19215.50.camel@joe-AO722>
Subject: Re: [PATCH] net: fec: Fix multicast list setup in fec_restart().
From: Joe Perches <joe@perches.com>
To: Christoph =?ISO-8859-1?Q?M=FCllner?= 
	<christoph.muellner@theobroma-systems.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>, netdev@vger.kernel.org
Date: Fri, 21 Jun 2013 10:25:08 -0700
In-Reply-To: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
References: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 18:40 +0200, Christoph Müllner wrote:
> Setup the multicast list of the net_device instead of
> clearing it blindly. This restores the multicast groups
> in case of a link down/up event.
> 
> Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>

Theobroma?
food of the gods or does your company just like chocolate?

> diff --git a/drivers/net/ethernet/freescale/fec_main.c
[]
> +static void set_multicast_list(struct net_device *ndev);
[]
> @@ -472,8 +474,7 @@ fec_restart(struct net_device *ndev, int duplex)
>         writel(0xffc00000, fep->hwp + FEC_IEVENT);
> 
>         /* Reset all multicast. */
> -       writel(0, fep->hwp + FEC_GRP_HASH_TABLE_HIGH);
> -       writel(0, fep->hwp + FEC_GRP_HASH_TABLE_LOW);
> +       set_multicast_list(ndev);

maybe dev_set_rx_mode(ndev) ?


