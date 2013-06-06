Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3FFXfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:35:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34407 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3FFXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:35:08 -0400
Date: Thu, 06 Jun 2013 16:35:06 -0700 (PDT)
Message-Id: <20130606.163506.962150797885004652.davem@davemloft.net>
To: Alexey.Brodkin@synopsys.com
Cc: netdev@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        Mischa.Jonker@synopsys.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, paul.gortmaker@windriver.com, sjhill@mips.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ethernet/arc/arc_emac - Add new driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com>
References: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Date: Tue, 4 Jun 2013 16:21:50 +0400

> +{
> +	struct arc_emac_priv *priv = netdev_priv(net_dev);
> +	struct phy_device *phydev = priv->phy_dev;
> +	u32 reg;
> +
> +	int status_change = 0;

Do not add empty lines amongst the top-level variable declarations
of a function.  Fix this in the entire driver, as needed.

> +			netdev_warn(net_dev,
> +				"Speed (%d) is not 10/100?\n", phydev->speed);

Functions calls on multiple lines must have the arguments
aligned properly on the second and subsequent lines, this
means:

		function(arg1, arg2,
			 arg3, arg4);

You must use the appropriate number of TAB and space characters
to achieve this proper column alignment, rather than only using
TAB characters as you have done here.

Audit and fix this in your entire driver.

> +static int arc_emac_get_settings(struct net_device *net_dev,
> +		struct ethtool_cmd *cmd)

The argument indention rules above apply to function definitions
as well.
