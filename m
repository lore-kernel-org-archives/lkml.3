Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3JQKxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:53:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:32045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab3JQKxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,513,1378882800"; 
   d="scan'208";a="412520433"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Adam Jackson <ajax@redhat.com>,
        Joe Perches <joe@perches.com>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next V3] mei: me: downgrade two errors to debug level
Date: Thu, 17 Oct 2013 13:52:10 +0300
Message-Id: <1382007130-20208-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

The mei_me driver prints "suspend" at error level at each suspend. It
also prints "stop" at error level at driver unload. Downgrade these
uninteresting messages to debug level.

Cc: Adam Jackson <ajax@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
0) v1 was called "mei: me: downgrade "suspend" message to debug level".

V2 also downgrades the "stop" message.

1) Added Adam and Joe to Cc:. They were involved in discussing a patch
 by Adam, which was similar to my v1, about a week ago.

2) Still lightly tested only, but now on top of v3.11.1.
V3: RESEND, it was not merged

 drivers/misc/mei/pci-me.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index d2ea9ff..1bf300e 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -232,7 +232,7 @@ static void mei_me_remove(struct pci_dev *pdev)
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
1.8.3.1

