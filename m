Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3CXQbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:31:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54644 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3CXQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:31:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Mar 2013 17:31:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: remove an always false test
Message-ID: <20130324173109.300a118f@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct fw_cdev_allocate_iso_resource.bandwidth is unsigned.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1365,8 +1365,7 @@ static int init_iso_resource(struct clie
 	int ret;
 
 	if ((request->channels == 0 && request->bandwidth == 0) ||
-	    request->bandwidth > BANDWIDTH_AVAILABLE_INITIAL ||
-	    request->bandwidth < 0)
+	    request->bandwidth > BANDWIDTH_AVAILABLE_INITIAL)
 		return -EINVAL;
 
 	r  = kmalloc(sizeof(*r), GFP_KERNEL);


-- 
Stefan Richter
-=====-===-= --== ==---
http://arcgraph.de/sr/
