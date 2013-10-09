Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3JIOQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:16:39 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37062 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3JIOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:16:37 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Simon Horman <horms+renesas@verge.net.au>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, Loc Ho <lho@apm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the clk tree
Date: Wed,  9 Oct 2013 16:14:24 +0200
Message-Id: <1381328067-1593-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381328067-1593-1-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the clk tree got a conflict in

	drivers/clk/Makefile

caused by commits f00578d (clk: emev2: Add support for emev2 SMU clocks
with DT), 6cfc229 (clk: keystone: Build Keystone clock drivers) and
308964c (clk: Add APM X-Gene SoC clock driver).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc drivers/clk/Makefile
index d25da26,df33820..fe3121b
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -32,7 -32,8 +32,9 @@@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500
  obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
  obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
  obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
 +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
+ obj-$(CONFIG_COMMON_CLK_XGENE)  += clk-xgene.o
+ obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/
  
  obj-$(CONFIG_X86)		+= x86/
  
