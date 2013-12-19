Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3LSPKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:10:52 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:35348 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3LSPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:06 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 25/38] pnp: card: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:36 +0100
Message-Id: <1387465429-3568-26-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/pnp/card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index bc00693..874c236 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -239,6 +239,7 @@ int pnp_add_card(struct pnp_card *card)
 	error = device_register(&card->dev);
 	if (error) {
 		dev_err(&card->dev, "could not register (err=%d)\n", error);
+		put_device(&card->dev);
 		return error;
 	}
 
-- 
1.8.3.1

