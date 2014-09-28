Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaI1So7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:44:59 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62292 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbaI1So5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:44:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4SAIdWKFRXQ6qa/2dsb2JhbABggw63MwsFAXKaUQQCfBcBe4QxLyOBGjeIQgGvWY8/hhKJKGQdhDUFnSiVXYNlOy+BBoFEAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ACPI / SBS: fix sparse warning
Date: Sun, 28 Sep 2014 20:44:47 +0200
Message-Id: <1411929887-2440-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding parentheses around expression to avoid:
drivers/acpi/sbs.c:444:28: warning: dubious: !x & y

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/acpi/sbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 32aecea..a7a3edd 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -441,7 +441,7 @@ static int acpi_ac_get_present(struct acpi_sbs *sbs)
 	 * The spec requires that bit 4 always be 1. If it's not set, assume
 	 * that the implementation doesn't support an SBS charger
 	 */
-	if (!(status >> 4) & 0x1)
+	if (!((status >> 4) & 0x1))
 		return -ENODEV;
 
 	sbs->charger_present = (status >> 15) & 0x1;
-- 
1.9.1

