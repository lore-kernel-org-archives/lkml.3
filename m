Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIVST0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:19:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52665 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaIVSTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:19:25 -0400
Date: Mon, 22 Sep 2014 14:19:21 -0400 (EDT)
Message-Id: <20140922.141921.577008114679288180.davem@davemloft.net>
To: hock.leong.kweh@intel.com
Cc: peppe.cavallaro@st.com, rayagond@vayavyalabs.com, vbridgers2013@gmail.com,
        wens@csie.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, tobias.johannes.klausmann@mni.thm.de
Subject: Re: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Sep 2014 11:19:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kweh Hock Leong <hock.leong.kweh@intel.com>
Date: Thu, 18 Sep 2014 20:34:10 +0800

> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> When the CONFIG_HAVE_CLK is selected for the system, the stmmac_pci_probe
> will fail with dmesg:
> [    2.167225] stmmaceth 0000:00:14.6: enabling device (0000 -> 0002)
> [    2.178267] stmmaceth 0000:00:14.6: enabling bus mastering
> [    2.178436] stmmaceth 0000:00:14.6: irq 24 for MSI/MSI-X
> [    2.178703] stmmaceth 0000:00:14.6: stmmac_dvr_probe: warning: cannot
> get CSR clock
> [    2.186503] stmmac_pci_probe: main driver probe failed
> [    2.194003] stmmaceth 0000:00:14.6: disabling bus mastering
> [    2.196473] stmmaceth: probe of 0000:00:14.6 failed with error -2
> 
> This patch fix the issue by breaking the dependency to devm_clk_get()
> as the CSR clock can be obtained at priv->plat->clk_csr from pci driver.
> 
> Reported-by: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>

Giuseppe, Kweh, where are we with this patch?
