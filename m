Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3ISKR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:17:29 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61280 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab3ISKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:17:27 -0400
Message-ID: <1379585845.1822.7.camel@x220.thuisdomein>
Subject: [PATCH v2] mei: me: downgrade two errors to debug level
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Adam Jackson <ajax@redhat.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Sep 2013 12:17:25 +0200
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AEC3CE1@HASMSX106.ger.corp.intel.com>
References: <1379013442.11313.5.camel@x220.thuisdomein>
	 <1379014276.11313.9.camel@x220.thuisdomein>
	 <5B8DA87D05A7694D9FA63FD143655C1B1AEC3CE1@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2013 10:17:25.0965 (UTC) FILETIME=[701A67D0:01CEB521]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mei_me driver prints "suspend" at error level at each suspend. It
also prints "stop" at error level at driver unload. Downgrade these
uninteresting messages to debug level.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was called "mei: me: downgrade "suspend" message to debug level".
v2 also downgrades the "stop" message.

1) Added Adam and Joe to Cc:. They were involved in discussing a patch
by Adam, which was similar to my v1, about a week ago.

2) Still lightly tested only, but now on top of v3.11.1.

 drivers/misc/mei/pci-me.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b3844e..897ee6b 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -231,7 +231,7 @@ static void mei_me_remove(struct pci_dev *pdev)
 	hw = to_me_hw(dev);
 
 
-	dev_err(&pdev->dev, "stop\n");
+	dev_dbg(&pdev->dev, "stop\n");
 	mei_stop(dev);
 
 	/* disable interrupts */
@@ -262,7 +262,7 @@ static int mei_me_pci_suspend(struct device *device)
 	if (!dev)
 		return -ENODEV;
 
-	dev_err(&pdev->dev, "suspend\n");
+	dev_dbg(&pdev->dev, "suspend\n");
 
 	mei_stop(dev);
 
-- 
1.8.1.4


