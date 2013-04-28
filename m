Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3D1WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 18:16:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37378 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3D1WQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 18:16:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 29 Apr 2013 00:16:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: typecast from gfp_t to bool more safely
Message-ID: <20130429001614.677012df@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An idr related patch introduced the following sparse warning:
  drivers/firewire/core-cdev.c:488:33: warning: incorrect type in initializer (different base types)
  drivers/firewire/core-cdev.c:488:33:    expected bool [unsigned] [usertype] preload
  drivers/firewire/core-cdev.c:488:33:    got restricted gfp_t
So let's convert from gfp_t bitfield to Boolean explicitly and safely.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -485,7 +485,7 @@ static int ioctl_get_info(struct client
 static int add_client_resource(struct client *client,
 			       struct client_resource *resource, gfp_t gfp_mask)
 {
-	bool preload = gfp_mask & __GFP_WAIT;
+	bool preload = !!(gfp_mask & __GFP_WAIT);
 	unsigned long flags;
 	int ret;
 


-- 
Stefan Richter
-=====-===-= -=-- ===-=
http://arcgraph.de/sr/
