Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3J2Sin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:38:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3J2Sik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:38:40 -0400
Message-ID: <527000AE.8060506@linux.com>
Date: Tue, 29 Oct 2013 19:38:38 +0100
From: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Linux IDE/ATA Dev <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] ata: libata-eh: Remove unnecessary snprintf arithmetic
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unnecessary arithmetic operation from a call to snprintf, because
the size parameter of snprintf includes the trailing null byte.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f9476fb..b7c4146 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2427,7 +2434,7 @@ static void ata_eh_link_report(struct ata_link *link)

 	memset(tries_buf, 0, sizeof(tries_buf));
 	if (ap->eh_tries < ATA_EH_MAX_TRIES)
-		snprintf(tries_buf, sizeof(tries_buf) - 1, " t%d",
+		snprintf(tries_buf, sizeof(tries_buf), " t%d",
 			 ap->eh_tries);

 	if (ehc->i.dev) {
