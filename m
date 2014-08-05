Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaHEQT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:19:57 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:62858 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaHEQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:19:56 -0400
From: jean-michel.hautbois@vodalys.com
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de
Cc: jhautbois@gmail.com,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] Lattice ECP3 FPGA: Check firmware pointer
Date: Tue,  5 Aug 2014 18:19:37 +0200
Message-Id: <1407255577-6946-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

This patch corrects a lack of testing.
If fw is NULL when calling firmware_load(), it results in a kernel oops.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/misc/lattice-ecp3-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 7ffdb58..7e1efd5 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -79,6 +79,11 @@ static void firmware_load(const struct firmware *fw, void *context)
	u32 jedec_id;
	u32 status;

+	if (fw == NULL) {
+		dev_err(&spi->dev, "Cannot load firmware, aborting\n");
+		return;
+	}
+
	if (fw->size == 0) {
		dev_err(&spi->dev, "Error: Firmware size is 0!\n");
		return;
--
2.0.4

