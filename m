Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3APAFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:05:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:43191 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3AOWdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 164/221] usb: musb: core: print new line in the driver banner again
Date: Tue, 15 Jan 2013 10:51:31 -0800
Message-Id: <20130115185009.882561969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 2ac788f705e5118dd45204e7a5bc8d5bb6873835 upstream.

Commit 5c8a86e10a7c164f44537fabdc169fd8b4e7a440 (usb: musb: drop unneeded
musb_debug trickery) erroneously removed '\n' from the driver's banner.
Concatenate all the banner substrings while adding it back...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2351,10 +2351,7 @@ static int __init musb_init(void)
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


