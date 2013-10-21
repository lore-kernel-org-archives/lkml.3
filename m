Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3JUJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:35:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55684 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3JUJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:35:24 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-a8-5264f55a817e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] spi/s3c64xx: Fix doubled clock disable on suspend
Date: Mon, 21 Oct 2013 11:35:17 +0200
Message-id: <1382348117-6666-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xy7pRX1OCDB7vk7KYtO4Ak8XUh0/Y
	LF6/MLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBaNH2+yWxx+087qwOXxd9ULZo9NqzrZ
	PDYvqffo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujDOT37AUnJGsWL7hOGMD4w6xLkZODgkB
	E4ml/46zQNhiEhfurWfrYuTiEBJYyihx5+JPZginj0ni4a8dYFVsAsYSm5cvYQOxRQSyJG7/
	2wJWxCwwmUni9MudjCAJYQEniSmztrF3MXJwsAioSvw6D7aNV8BN4uKsuUwgYQkBBYk5k2wm
	MHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESPl93MC49ZnWIUYCDUYmHN8AlJUiI
	NbGsuDL3EKMEB7OSCO/nj0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjMuWHQg3aZdvvBlmyqy8
	7stlf+uGNmeGZx1cWZtOfd4kWfZYT2xnc9XV7a6GRzt8V0Wd/+mu/2JODc+cOun7bfevLb1U
	MFU9MvJfT/gFXtlZgscsInTKD9XsW5vep/xv1pU3YgzPQjhsT1cGKl1vEXSat8s4QlUsSTnz
	4x7+TMUCheXJsi+tlFiKMxINtZiLihMBu8Qh9/0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix doubled clock disable and unprepare during PM suspend which triggered
the warnings:

WARNING: at drivers/clk/clk.c:800 clk_disable+0x18/0x24()
Modules linked in:
CPU: 0 PID: 1745 Comm: sh Not tainted 3.10.14-01211-ge2549bb-dirty #62
[<c0015980>] (unwind_backtrace+0x0/0x138) from [<c0012a44>] (show_stack+0x10/0x14)
[<c0012a44>] (show_stack+0x10/0x14) from [<c0022818>] (warn_slowpath_common+0x4c/0x68)
[<c0022818>] (warn_slowpath_common+0x4c/0x68) from [<c0022850>] (warn_slowpath_null+0x1c/0x24)
[<c0022850>] (warn_slowpath_null+0x1c/0x24) from [<c036e274>] (clk_disable+0x18/0x24)
[<c036e274>] (clk_disable+0x18/0x24) from [<c02d5f78>] (s3c64xx_spi_suspend+0x28/0x54)
[<c02d5f78>] (s3c64xx_spi_suspend+0x28/0x54) from [<c02b3a54>] (platform_pm_suspend+0x2c/0x5c)
[<c02b3a54>] (platform_pm_suspend+0x2c/0x5c) from [<c02b8a30>] (dpm_run_callback+0x44/0x7c)
[<c02b8a30>] (dpm_run_callback+0x44/0x7c) from [<c02b8b70>] (__device_suspend+0x108/0x300)
[<c02b8b70>] (__device_suspend+0x108/0x300) from [<c02ba4e0>] (dpm_suspend+0x54/0x208)
[<c02ba4e0>] (dpm_suspend+0x54/0x208) from [<c0066bcc>] (suspend_devices_and_enter+0x98/0x458)
[<c0066bcc>] (suspend_devices_and_enter+0x98/0x458) from [<c0067150>] (pm_suspend+0x1c4/0x25c)
[<c0067150>] (pm_suspend+0x1c4/0x25c) from [<c0066044>] (state_store+0x6c/0xbc)
[<c0066044>] (state_store+0x6c/0xbc) from [<c0203290>] (kobj_attr_store+0x14/0x20)
[<c0203290>] (kobj_attr_store+0x14/0x20) from [<c0157530>] (sysfs_write_file+0xfc/0x164)
[<c0157530>] (sysfs_write_file+0xfc/0x164) from [<c00fd6b0>] (vfs_write+0xbc/0x1bc)
[<c00fd6b0>] (vfs_write+0xbc/0x1bc) from [<c00fdaf0>] (SyS_write+0x40/0x68)
[<c00fdaf0>] (SyS_write+0x40/0x68) from [<c000ea80>] (ret_fast_syscall+0x0/0x3c)

The clocks are already disabled before suspending.

Additionally add PM runtime get() and put() during resume so device
won't sleep for the time of s3c64xx_spi_hwinit().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index a80376d..374be7d 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1482,10 +1482,6 @@ static int s3c64xx_spi_suspend(struct device *dev)
 
 	spi_master_suspend(master);
 
-	/* Disable the clock */
-	clk_disable_unprepare(sdd->src_clk);
-	clk_disable_unprepare(sdd->clk);
-
 	sdd->cur_speed = 0; /* Output Clock is stopped */
 
 	return 0;
@@ -1496,16 +1492,19 @@ static int s3c64xx_spi_resume(struct device *dev)
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
+	int ret;
 
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "pm runtime failed, e = %d\n", ret);
+		return ret;
+	}
 	if (sci->cfg_gpio)
 		sci->cfg_gpio();
 
-	/* Enable the clock */
-	clk_prepare_enable(sdd->src_clk);
-	clk_prepare_enable(sdd->clk);
-
 	s3c64xx_spi_hwinit(sdd, sdd->port_id);
 
+	pm_runtime_put(dev);
 	spi_master_resume(master);
 
 	return 0;
-- 
1.7.9.5

