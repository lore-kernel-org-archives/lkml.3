Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3IWSQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:11 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:58369 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab3IWSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:08 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 01/13] tpm: ibmvtpm: Use %zd formatting for size_t format arguments
Date: Mon, 23 Sep 2013 12:14:31 -0600
Message-Id: <1379960083-8942-2-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This suppresses compile warnings on 32 bit builds.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 56b07c3..838f043 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -98,7 +98,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (count < len) {
 		dev_err(ibmvtpm->dev,
-			"Invalid size in recv: count=%ld, crq_size=%d\n",
+			"Invalid size in recv: count=%zd, crq_size=%d\n",
 			count, len);
 		return -EIO;
 	}
@@ -136,7 +136,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (count > ibmvtpm->rtce_size) {
 		dev_err(ibmvtpm->dev,
-			"Invalid size in send: count=%ld, rtce_size=%d\n",
+			"Invalid size in send: count=%zd, rtce_size=%d\n",
 			count, ibmvtpm->rtce_size);
 		return -EIO;
 	}
-- 
1.8.1.2

