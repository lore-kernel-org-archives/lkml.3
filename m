Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDFWTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 18:19:41 -0400
Received: from 200.180.216.87.static.jazztel.es ([87.216.180.200]:43554 "HELO
	mail.sysvalve.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753191AbaDFWTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 18:19:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Apr 2014 18:19:16 EDT
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>, Chris Bajumpaa <cbajumpa@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging/line6: Fix kzalloc coding style issue
Date: Mon,  7 Apr 2014 00:12:30 +0200
Message-Id: <1396822352-14555-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the actual variable to sizeof instead of a type definition.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/line6/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 661080b..a3136b1 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -475,7 +475,7 @@ int line6_init_pcm(struct usb_line6 *line6,
 		MISSING_CASE;
 	}
 
-	line6pcm = kzalloc(sizeof(struct snd_line6_pcm), GFP_KERNEL);
+	line6pcm = kzalloc(sizeof(*line6pcm), GFP_KERNEL);
 
 	if (line6pcm == NULL)
 		return -ENOMEM;
-- 
1.9.1

