Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3KOOXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:23:35 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53001 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3KOOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:22:45 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mmc: mvsdio: silence card detect notice
Date: Fri, 15 Nov 2013 15:22:34 +0100
Message-Id: <1384525354-901-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvsdio reports method of card detection with dev_notice, while for
removable cards it may be sane, for non-removable cards it is not.
Also, as the user cannot do anything about it, silence the message
by reducing it from dev_notice to dev_dbg.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/mvsdio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 25f51be..d17b399 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -816,10 +816,9 @@ static int __init mvsd_probe(struct platform_device *pdev)
 		goto out;
 
 	if (!(mmc->caps & MMC_CAP_NEEDS_POLL))
-		dev_notice(&pdev->dev, "using GPIO for card detection\n");
+		dev_dbg(&pdev->dev, "using GPIO for card detection\n");
 	else
-		dev_notice(&pdev->dev,
-			   "lacking card detect (fall back to polling)\n");
+		dev_dbg(&pdev->dev, "lacking card detect, fall back to polling\n");
 	return 0;
 
 out:
-- 
1.7.2.5

