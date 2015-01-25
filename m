Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbbAYSrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:47:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbbAYSKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.18 089/183] Revert "clk: ppc-corenet: Fix Section mismatch warning"
Date: Sun, 25 Jan 2015 10:06:51 -0800
Message-Id: <20150125180814.050239814@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit 176a107b868781c8d6868454aea7d07e0b82d6b8 upstream.

This reverts commit da788acb28386aa896224e784954bb73c99ff26c.

That commit tried to fix the section mismatch warning by moving the
ppc_corenet_clk_driver struct to init section. This is definitely wrong
because the kernel would free the memories occupied by this struct
after boot while this driver is still registered in the driver core.
The kernel would panic when accessing this driver struct.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-ppc-corenet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-ppc-corenet.c
@@ -291,7 +291,7 @@ static const struct of_device_id ppc_clk
 	{}
 };
 
-static struct platform_driver ppc_corenet_clk_driver __initdata = {
+static struct platform_driver ppc_corenet_clk_driver = {
 	.driver = {
 		.name = "ppc_corenet_clock",
 		.owner = THIS_MODULE,


