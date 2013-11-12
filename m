Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3KLTHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:43 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39593 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3KLTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pcmcia@lists.infradead.org
Subject: [PATCH 05/12] pcmcia: Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:18 +0100
Message-Id: <1384283245-9419-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pcmcia@lists.infradead.org
---
 drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
 drivers/pcmcia/electra_cf.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index ed3b522601b3..971991bab975 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -303,7 +303,7 @@ static int bfin_cf_remove(struct platform_device *pdev)
 
 static struct platform_driver bfin_cf_driver = {
 	.driver = {
-		   .name = (char *)driver_name,
+		   .name = driver_name,
 		   .owner = THIS_MODULE,
 		   },
 	.probe = bfin_cf_probe,
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 1b206eac5f93..5ea64d0f61ab 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -359,7 +359,7 @@ MODULE_DEVICE_TABLE(of, electra_cf_match);
 
 static struct platform_driver electra_cf_driver = {
 	.driver = {
-		.name = (char *)driver_name,
+		.name = driver_name,
 		.owner = THIS_MODULE,
 		.of_match_table = electra_cf_match,
 	},
-- 
1.7.9.5

