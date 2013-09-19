Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3ISWBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:01:24 -0400
Received: from www17.your-server.de ([213.133.104.17]:57475 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:21 -0400
Subject: [PATCH 6/10] staging: octeon-usb: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755853-161070036-6-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/octeon-usb/cvmx-usb.c b/drivers/staging/octeon-usb/cvmx-usb.c
--- a/drivers/staging/octeon-usb/cvmx-usb.c
+++ b/drivers/staging/octeon-usb/cvmx-usb.c
@@ -604,7 +604,7 @@ int cvmx_usb_initialize(struct cvmx_usb_
 			}
 	}
 
-	memset(usb, 0, sizeof(usb));
+	memset(usb, 0, sizeof(*usb));
 	usb->init_flags = flags;
 
 	/* Initialize the USB state structure */
