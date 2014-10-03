Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaJCXVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:21:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbaJCWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Loc Ho <lho@apm.com>, Suman Tripathi <stripathi@apm.com>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 350/357] ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Fri,  3 Oct 2014 14:32:16 -0700
Message-Id: <20141003212943.967413650@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Tripathi <stripathi@apm.com>

commit 72f79f9e35bd3f78ee8853f2fcacaa197d23ebac upstream.

This patch removes the NCQ support from the APM X-Gene SoC AHCI
Host Controller driver as it doesn't support it.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[bwh: Backported to 3.16: host flags are passed to ahci_platform_init_host()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_xgene.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -337,7 +337,7 @@ static struct ata_port_operations xgene_
 };
 
 static const struct ata_port_info xgene_ahci_port_info = {
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags = AHCI_FLAG_COMMON,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
@@ -484,7 +484,7 @@ static int xgene_ahci_probe(struct platf
 		goto disable_resources;
 	}
 
-	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
+	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
 				     hflags, 0, 0);


