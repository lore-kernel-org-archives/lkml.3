Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3AXD1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:27:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3AXD1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 02/74] usb: musb: core: print new line in the driver banner again
Date: Thu, 24 Jan 2013 01:26:14 -0200
Message-Id: <1358998046-613-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 2ac788f705e5118dd45204e7a5bc8d5bb6873835 upstream.

Commit 5c8a86e10a7c164f44537fabdc169fd8b4e7a440 (usb: musb: drop unneeded
musb_debug trickery) erroneously removed '\n' from the driver's banner.
Concatenate all the banner substrings while adding it back...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/musb/musb_core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index db3dff8..fde4898 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2402,10 +2402,7 @@ static int __init musb_init(void)
 	if (usb_disabled())
 		return 0;
 
-	pr_info("%s: version " MUSB_VERSION ", "
-		"?dma?"
-		", "
-		"otg (peripheral+host)",
+	pr_info("%s: version " MUSB_VERSION ", ?dma?, otg (peripheral+host)\n",
 		musb_driver_name);
 	return platform_driver_register(&musb_driver);
 }
-- 
1.7.9.5

