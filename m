Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaDXIwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDXIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/182] tgafb: potential NULL dereference in init
Date: Thu, 24 Apr 2014 09:48:53 +0100
Message-Id: <1398329507-5911-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0ede5804ca3b42c831f7440ec29bc7187e5376bb upstream.

Static checkers complain that there are paths where "tga_type_name" can
be NULL.  I've re-arranged the code slightly so that's impossible.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/tgafb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index c9c8e5a..ef894b3 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -1496,10 +1496,9 @@ tgafb_init_fix(struct fb_info *info)
 		if (tga_bus_tc)
 			tga_type_name = "Digital ZLX-E3";
 		break;
-	default:
-		tga_type_name = "Unknown";
-		break;
 	}
+	if (!tga_type_name)
+		tga_type_name = "Unknown";
 
 	strlcpy(info->fix.id, tga_type_name, sizeof(info->fix.id));
 
-- 
1.9.1

