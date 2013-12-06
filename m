Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3LFV0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:26:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42680 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab3LFV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:26:08 -0500
Date: Fri, 06 Dec 2013 16:26:06 -0500 (EST)
Message-Id: <20131206.162606.2277176361893801778.davem@davemloft.net>
To: wens@csie.org
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        srinivas.kandagatla@st.com, maxime.ripard@free-electrons.com
Subject: Re: [PATCH 02/10] net: stmmac: Honor DT parameter to force DMA
 store and forward mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386350983-13281-3-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
	<1386350983-13281-3-git-send-email-wens@csie.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 13:26:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>
Date: Sat,  7 Dec 2013 01:29:35 +0800

> @@ -47,6 +47,7 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
>  		plat->bus_id = 0;
>  
>  	of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr);
> +	plat->force_sf_dma_mode = of_property_read_bool(np, "snps,force_sf_dma_mode");

Will this do the right thing for when the property is not present?
Right now the force_sf_dma_mode value is always false.

In fact won't it override the explicit settings done elsewhere in the
driver?
