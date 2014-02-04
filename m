Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976AbaBDWMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:12:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934041AbaBDVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Guinot <simon.guinot@sequanux.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 086/133] ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
Date: Tue,  4 Feb 2014 13:08:07 -0800
Message-Id: <20140204210739.461020217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/ata/marvell.txt |    2 +-
 drivers/ata/sata_mv.c                             |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

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
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4209,6 +4209,7 @@ static int mv_platform_resume(struct pla
 
 #ifdef CONFIG_OF
 static struct of_device_id mv_sata_dt_ids[] = {
+	{ .compatible = "marvell,armada-370-sata", },
 	{ .compatible = "marvell,orion-sata", },
 	{},
 };


