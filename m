Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaCHS6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:58:36 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58479 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaCHS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:58:22 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/4] mei: Don't log an error when the MEI device is quirked off
Date: Sat,  8 Mar 2014 10:58:12 -0800
Message-Id: <9bdf4f25e7c57bccd20d7470271b7e385aac270a.1394304585.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an administrator wants to use MEI, they can search the logs for
'mei'.  Otherwise they don't need a glaring reminder that their
hardware doesn't actually support MEI.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/misc/mei/pci-me.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index ddadd08..809021e 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -127,7 +127,7 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (!mei_me_quirk_probe(pdev, ent)) {
 		err = -ENODEV;
-		goto end;
+		return err;  /* No point in logging an error. */
 	}
 
 	/* enable pci dev */
-- 
1.8.5.3

