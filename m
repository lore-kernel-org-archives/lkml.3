Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaGWJlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:40 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35915 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668AbaGWJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:34 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: comedi: ni_65xx: disable edge detection on initialization
Date: Wed, 23 Jul 2014 10:41:21 +0100
Message-Id: <1406108481-23910-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
References: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the hardware is being initialized, the edge detection interrupts
are cleared and disabled.  Also disable edge detection for all channels
at this time so they start off in a known state.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index ddf9135..1b8a397 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -804,6 +804,7 @@ static int ni_65xx_auto_attach(struct comedi_device *dev,
 	}
 
 	ni_65xx_disable_input_filters(dev);
+	ni_65xx_disable_edge_detection(dev);
 
 	return 0;
 }
-- 
2.0.0

