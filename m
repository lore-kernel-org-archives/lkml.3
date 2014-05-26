Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaEZTJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:09:13 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:53262 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbaEZTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:09:11 -0400
Message-ID: <1401131350.6068.20.camel@x220>
Subject: [PATCH] staging: comedi: remove check for CONFIG_KMOD
From: Paul Bolle <pebolle@tiscali.nl>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:09:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:09:10.0211 (UTC) FILETIME=[F95FC130:01CF7915]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi driver was added in v2.6.29. That's the same release that
removed the Kconfig symbol KMOD. So the code behind a test for its
macro has been hidden since it was in staging. Remove it.

Remove a useless assignment to "dev->in_request_module" too. That
variable seems pointless anyhow, but that's a different issue.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Done on top of next-20140526.

 drivers/staging/comedi/comedi_fops.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 012c8fd1aabb..70ad00c501ef 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2351,14 +2351,6 @@ static int comedi_open(struct inode *inode, struct file *file)
 	if (capable(CAP_NET_ADMIN) && dev->in_request_module)
 		goto ok;
 
-	dev->in_request_module = true;
-
-#ifdef CONFIG_KMOD
-	mutex_unlock(&dev->mutex);
-	request_module("char-major-%i-%i", COMEDI_MAJOR, dev->minor);
-	mutex_lock(&dev->mutex);
-#endif
-
 	dev->in_request_module = false;
 
 	if (!dev->attached && !capable(CAP_NET_ADMIN)) {
-- 
1.9.0

