Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3FUKc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:32:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39826 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185Ab3FUKc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:32:56 -0400
Message-ID: <1371810775.19215.30.camel@joe-AO722>
Subject: Re: [PATCH v7] ethernet/arc/arc_emac - Add new driver
From: Joe Perches <joe@perches.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: netdev@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Florian Fainelli <florian@openwrt.org>
Date: Fri, 21 Jun 2013 03:32:55 -0700
In-Reply-To: <1371799241-27771-1-git-send-email-abrodkin@synopsys.com>
References: <1371799241-27771-1-git-send-email-abrodkin@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 11:20 +0400, Alexey Brodkin wrote:
> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> ARCAngel4/ML50x.

Looks fine to me.

One nit you could fix later and a question.

> diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
[]
> +static int arc_emac_rx(struct net_device *ndev, int budget)
> +{
[]
> +			if (net_ratelimit())
> +				netdev_err(ndev, "incomplete packed received\n");

s/packed/packet/

> +		rxbd->data = (unsigned char *)cpu_to_le32(rx_buff->skb->data);

32 bit only.  Should the Kconfig block have some arch_arc dependency
so it can't get compiled for 64 bit systems?

