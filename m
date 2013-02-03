Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3BCOyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34062 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab3BCOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:43 -0500
Message-Id: <20130203144644.260247573@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 002/128] usb: musb: core: print new line in the driver banner again
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 2ac788f705e5118dd45204e7a5bc8d5bb6873835 upstream.

Commit 5c8a86e10a7c164f44537fabdc169fd8b4e7a440 (usb: musb: drop unneeded
musb_debug trickery) erroneously removed '\n' from the driver's banner.
Concatenate all the banner substrings while adding it back...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/musb/musb_core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2372,10 +2372,7 @@ static int __init musb_init(void)
 	if (usb_disabled())
 		return 0;
 
-	pr_info("%s: version " MUSB_VERSION ", "
-		"?dma?"
-		", "
-		"otg (peripheral+host)",
+	pr_info("%s: version " MUSB_VERSION ", ?dma?, otg (peripheral+host)\n",
 		musb_driver_name);
 	return platform_driver_probe(&musb_driver, musb_probe);
 }


