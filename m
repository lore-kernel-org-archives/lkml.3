Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423333Ab3FURPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:15:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53849 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422925Ab3FURPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
References: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
Date: Fri, 21 Jun 2013 14:15:40 -0300
Message-ID: <CAOMZO5CyK9S-Wmm+ihBeMCaDBJyxBb-vSQjzZiKrmz74mb=vDw@mail.gmail.com>
Subject: Re: [PATCH] net: fec: Fix multicast list setup in fec_restart().
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Christoph_M=C3=BCllner?= 
	<christoph.muellner@theobroma-systems.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 1:40 PM, Christoph Müllner
<christoph.muellner@theobroma-systems.com> wrote:

> @@ -472,8 +474,7 @@ fec_restart(struct net_device *ndev, int duplex)
>         writel(0xffc00000, fep->hwp + FEC_IEVENT);
>
>         /* Reset all multicast. */

Should this comment be removed/updated now?

> -       writel(0, fep->hwp + FEC_GRP_HASH_TABLE_HIGH);
> -       writel(0, fep->hwp + FEC_GRP_HASH_TABLE_LOW);
> +       set_multicast_list(ndev);
