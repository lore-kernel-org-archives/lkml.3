Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaIZQi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:38:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37308 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaIZQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:38:26 -0400
Message-ID: <5425967F.7020002@gmail.com>
Date: Sat, 27 Sep 2014 00:38:23 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When failure occurs, after xenbus_dev_error(), need go to fail to let
upper caller know about it.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/xen-scsiback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 847bc9c..3e430e1 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1222,8 +1222,10 @@ static int scsiback_probe(struct xenbus_device *dev,
 
 	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
 			    SG_ALL);
-	if (err)
+	if (err) {
 		xenbus_dev_error(dev, err, "writing feature-sg-grant");
+		goto fail;
+	}
 
 	xenbus_switch_state(dev, XenbusStateInitWait);
 	return 0;
-- 
1.9.3
