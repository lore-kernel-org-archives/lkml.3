Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaLNUrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:47:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLNUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 17/34] sata_fsl: fix error handling of irq_of_parse_and_map
Date: Sun, 14 Dec 2014 12:20:55 -0800
Message-Id: <20141214201804.290811486@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@chromium.org>

commit aad0b624129709c94c2e19e583b6053520353fa8 upstream.

irq_of_parse_and_map() returns 0 on error (the result is unsigned int),
so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_fsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1503,7 +1503,7 @@ static int sata_fsl_probe(struct platfor
 	host_priv->csr_base = csr_base;
 
 	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}


