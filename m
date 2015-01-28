Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbbA1BiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012AbbA1B2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suman Tripathi <stripathi@apm.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.18 48/61] ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA controller driver.
Date: Tue, 27 Jan 2015 17:27:00 -0800
Message-Id: <20150128012642.139650472@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Tripathi <stripathi@apm.com>

commit 5c0b8e0de76a86edb99e46612fd9d341b4c4fa0a upstream.

This patch fixes the big endian mode issue with function
xgene_ahci_read_id.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_xgene.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -188,7 +188,7 @@ static unsigned int xgene_ahci_read_id(s
 	 *
 	 * Clear reserved bit 8 (DEVSLP bit) as we don't support DEVSLP
 	 */
-	id[ATA_ID_FEATURE_SUPP] &= ~(1 << 8);
+	id[ATA_ID_FEATURE_SUPP] &= cpu_to_le16(~(1 << 8));
 
 	return 0;
 }


