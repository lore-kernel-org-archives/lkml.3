Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3LSPQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:16:05 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57714 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LSPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:19 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/38] arm: mach-rpc: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:19 +0100
Message-Id: <1387465429-3568-9-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/arm/mach-rpc/ecard.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index fcb1d59..1c5f7cb 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -961,8 +961,10 @@ static int __init ecard_probe(int slot, unsigned irq, card_type_t type)
 	slot_to_expcard[slot] = ec;
 
 	rc = device_register(&ec->dev);
-	if (rc)
+	if (rc) {
+		put_device(&ec->dev);
 		goto nodev;
+	}
 
 	return 0;
 
-- 
1.8.3.1

