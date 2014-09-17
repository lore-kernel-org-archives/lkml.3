Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaIQTDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:03:30 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:17035 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbaIQTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HFoQ1BZ0MjDKJFoIbgUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-parisc@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 1/6] video: fbdev: stifb.c: use container_of to resolve stifb_info from fb_info
Date: Wed, 17 Sep 2014 21:00:14 +0200
Message-Id: <1410980419-5326-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410980419-5326-1-git-send-email-fabf@skynet.be>
References: <1410980419-5326-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
PARISC cross-compiled but untested.

 drivers/video/fbdev/stifb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index cfe8a2f..86621fa 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -918,7 +918,7 @@ static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
 {
-	struct stifb_info *fb = (struct stifb_info *) info;
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 	u32 color;
 
 	if (regno >= NR_PALETTE)
@@ -978,7 +978,7 @@ stifb_setcolreg(u_int regno, u_int red, u_int green,
 static int
 stifb_blank(int blank_mode, struct fb_info *info)
 {
-	struct stifb_info *fb = (struct stifb_info *) info;
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 	int enable = (blank_mode == 0) ? ENABLE : DISABLE;
 
 	switch (fb->id) {
-- 
2.1.0

