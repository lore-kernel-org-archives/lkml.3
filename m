Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbbARXZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 18:25:36 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:55744 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbARXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 18:25:35 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: platform-driver-x86@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH v2 1/3] asus-laptop: fix is_visible return value
Date: Sun, 18 Jan 2015 18:25:24 -0500
Message-Id: <1421623526-20555-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a Lucid platform, asus_sysfs_is_visible() returned a boolean for
ls_switch and ls_level attributes.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/platform/x86/asus-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index f71700e..00f5e82 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1616,7 +1616,7 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 		else
 			goto normal;
 
-		return supported;
+		return supported ? attr->mode : 0;
 	}
 
 normal:
-- 
2.2.2

