Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3JUNnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:43:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33200 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3JUNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:43:03 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d9-52652f64a219
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] spi/s3c64xx: Fix doubled clock disable on suspend
Date: Mon, 21 Oct 2013 15:42:50 +0200
Message-id: <1382362971-16763-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
References: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Nd0U/dQgg40ThCwmrTvAZDH14RM2
	i9cvDC16F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk0Xjx5vsFofftLM6cHn8XfWC2WPTqk42
	j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEro3vrRNaCAxIVjV+3MTYwXhTtYuTkkBAw
	kfj6fh8LhC0mceHeerYuRi4OIYGljBJnLr9ihnD6mCTe/D/BBlLFJmAssXn5EjBbRCBL4va/
	LWBFzAKTmSROv9zJCJIQFnCT+P2gDcxmEVCVOD55GlgDr4C7xJE3+9i7GDmA1ilIzJlkAxLm
	FPCQOPniOBOILQRUMundDOYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE3Jcd
	jIuPWR1iFOBgVOLhDXBJCRJiTSwrrsw9xCjBwawkwvv5I1CINyWxsiq1KD++qDQntfgQIxMH
	p1QD44Ks/6/Mpvy5p81oOW3D5+a2xL0nvV4yJvm+Mg9cwHPbfJXYNN+X3BcPbS9j+RDgZLg+
	pjW2y1cqYJ+ZiR9Tf9LUR9qi6yf3/zJL3vf5aqEx+4WdkhPN05d0ngrlW+xWr/z3xpyG1ZdN
	K1Ok7Dz2mf3y+hI2ReD6mVcTNp5Q2Cw/m9XK40zTMyWW4oxEQy3mouJEAMjN+bcWAgAA
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

The clocks may be already disabled before suspending. Check PM runtime
suspend status and disable clocks only if device is not suspended.
During resume do not enable the clocks if device is runtime suspended.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 59f4fd9..8953178 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1484,9 +1484,10 @@ static int s3c64xx_spi_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
-	/* Disable the clock */
-	clk_disable_unprepare(sdd->src_clk);
-	clk_disable_unprepare(sdd->clk);
+	if (!pm_runtime_suspended(dev)) {
+		clk_disable_unprepare(sdd->clk);
+		clk_disable_unprepare(sdd->src_clk);
+	}
 
 	sdd->cur_speed = 0; /* Output Clock is stopped */
 
@@ -1502,9 +1503,10 @@ static int s3c64xx_spi_resume(struct device *dev)
 	if (sci->cfg_gpio)
 		sci->cfg_gpio();
 
-	/* Enable the clock */
-	clk_prepare_enable(sdd->src_clk);
-	clk_prepare_enable(sdd->clk);
+	if (!pm_runtime_suspended(dev)) {
+		clk_prepare_enable(sdd->src_clk);
+		clk_prepare_enable(sdd->clk);
+	}
 
 	s3c64xx_spi_hwinit(sdd, sdd->port_id);
 
-- 
1.7.9.5

