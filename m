Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaH3DG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:06:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52587 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaH3DGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:06:24 -0400
Date: Fri, 29 Aug 2014 20:06:23 -0700 (PDT)
Message-Id: <20140829.200623.1931173830496862001.davem@davemloft.net>
To: hock.leong.kweh@intel.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boon.leong.ong@intel.com
Subject: Re: [PATCH 1/4] net: stmmac: enhance to support multiple device
 instances
From: David Miller <davem@davemloft.net>
In-Reply-To: <cf29eb9e793cf67b99b455f3a4a55e7aca5d826c.1409123378.git.hock.leong.kweh@intel.com>
References: <cover.1409123378.git.hock.leong.kweh@intel.com>
	<cover.1409123378.git.hock.leong.kweh@intel.com>
	<cf29eb9e793cf67b99b455f3a4a55e7aca5d826c.1409123378.git.hock.leong.kweh@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 Aug 2014 20:06:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kweh Hock Leong <hock.leong.kweh@intel.com>
Date: Wed, 27 Aug 2014 18:32:26 +0800

> @@ -26,27 +26,22 @@
>  #include <linux/pci.h>
>  #include "stmmac.h"
>  
> -static struct plat_stmmacenet_data plat_dat;
> -static struct stmmac_mdio_bus_data mdio_data;
> -static struct stmmac_dma_cfg dma_cfg;
> +static int instance_id = 1;

Don't do this instance stuff.  Instead pull in some identifier that
can come from elsewhere.

> +	plat_dat->mdio_bus_data = devm_kzalloc(&pdev->dev,
> +				    sizeof(*plat_dat->mdio_bus_data),
> +				    GFP_KERNEL);

This is not indented properly.

On the second and subsequent lines of a multi-line function call,
the lines should start exactly at the first column after the openning
parenthesis of the first line.

You must use the correct number of TAB and SPACE characters necessary
to do so.  Generally speaking, if you are indenting using only TAB
characters, odds are you are doing it wrong.

Please audit for, and fix this, in your entire patch series.
