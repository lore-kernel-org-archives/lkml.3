Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaHUXjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:39:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44142 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaHUXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:39:19 -0400
Date: Thu, 21 Aug 2014 16:39:18 -0700 (PDT)
Message-Id: <20140821.163918.1714927909558457176.davem@davemloft.net>
To: reksio@newterm.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ec_bhf: remove excessive debug messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140815154941.GA16632@newterm.pl>
References: <20140815154941.GA16632@newterm.pl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 16:39:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dariusz Marcinkiewicz <reksio@newterm.pl>
Date: Fri, 15 Aug 2014 17:49:41 +0200

> This cuts down on the number of debug information spit out by
> the driver. Some of the potentially useful debug info gets exposed
> by debugfs.
> 
> Signed-off-by: Dariusz Marcinkiewicz <reksio@newterm.pl>

I think you should just flat out remove a lot of this stuff:

> +static struct debugfs_reg32 ec_bhf_debugfs_mii_regs[] = {
> +	{
> +		.name = "link-status",
> +		.offset = MII_LINK_STATUS
> +	}
> +};

This is completely unnecessary, if you want to export MII register
values to the user, we have a mechanism for that, via the SIOCGMII*
ioctls.

> +static struct debugfs_reg32 ec_bhf_debugfs_fifo_regs[] = {
> +	{
> +		.name = "fifo-tx",
> +		.offset = FIFO_TX_REG
> +	},
> +	{
> +		.name = "fifo-rx",
> +		.offset = FIFO_RX_REG
> +	}
> +};

You can export chip register values via the ethtool register dump API.
Simply implement ethtool_ops->get_regs_len and ethtool_ops->get_regs
and off you go.
