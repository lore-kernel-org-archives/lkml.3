Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaBJT5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:57:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaBJTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Guinot <simon.guinot@sequanux.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 065/124] ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
Date: Mon, 10 Feb 2014 11:40:05 -0800
Message-Id: <1392061264-28124-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <simon.guinot@sequanux.org>

commit b1f5c73bd5a4752efb7d7af019034044b08aafe9 upstream.

The sata_mv driver supports the SATA IP found in several Marvell SoCs.
As some new SATA registers have been introduced with the Armada 370/XP
SoCs, a way to identify them is needed.

This patch introduces a new compatible string for the SATA IP found in
Armada 370/XP SoCs.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Lior Amsalem <alior@marvell.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/devicetree/bindings/ata/marvell.txt | 2 +-
 drivers/ata/sata_mv.c                             | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ata/marvell.txt b/Documentation/devicetree/bindings/ata/marvell.txt
index b5cdd20..1c83516 100644
--- a/Documentation/devicetree/bindings/ata/marvell.txt
+++ b/Documentation/devicetree/bindings/ata/marvell.txt
@@ -1,7 +1,7 @@
 * Marvell Orion SATA
 
 Required Properties:
-- compatibility : "marvell,orion-sata"
+- compatibility : "marvell,orion-sata" or "marvell,armada-370-sata"
 - reg           : Address range of controller
 - interrupts    : Interrupt controller is using
 - nr-ports      : Number of SATA ports in use.
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 35c6b6d..9258775 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4216,6 +4216,7 @@ static int mv_platform_resume(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static struct of_device_id mv_sata_dt_ids[] = {
+	{ .compatible = "marvell,armada-370-sata", },
 	{ .compatible = "marvell,orion-sata", },
 	{},
 };
-- 
1.8.3.2

