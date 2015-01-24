Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbbAXAaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:30:16 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47532 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAXAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:30:14 -0500
Date: Fri, 23 Jan 2015 16:30:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Heiko Stuebner <heiko@sntech.de>,
        Chris Ball <chris@printf.net>, Doug Anderson <dianders@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, linux-mmc@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: rockchip: remove incorrect __exit_p()
Message-ID: <20150124003009.GA14891@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw_mci_pltfm_remove() is not (nor should it be) marked as __exit,
so we should not be using __exit_p() wrapper with it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/mmc/host/dw_mmc-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
index 5650ac4..e2a726a 100644
--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -133,7 +133,7 @@ static SIMPLE_DEV_PM_OPS(dw_mci_rockchip_pmops,
 
 static struct platform_driver dw_mci_rockchip_pltfm_driver = {
 	.probe		= dw_mci_rockchip_probe,
-	.remove		= __exit_p(dw_mci_pltfm_remove),
+	.remove		= dw_mci_pltfm_remove,
 	.driver		= {
 		.name		= "dwmmc_rockchip",
 		.of_match_table	= dw_mci_rockchip_match,
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
