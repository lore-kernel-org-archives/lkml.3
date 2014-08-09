Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaHIAg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:36:57 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:51080
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbaHIAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] au0828: remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_*()
Date: Fri,  8 Aug 2014 18:36:19 -0600
Message-Id: <cae8929faf952b312460a09b8b05c7875b4c560f.1407544065.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407544065.git.shuah.kh@samsung.com>
References: <cover.1407544065.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1407544065.git.shuah.kh@samsung.com>
References: <cover.1407544065.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_register()
and au0828_rc_unregister() calls in au0828-core

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index eb5f2b1..2090498 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -153,9 +153,7 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 
 	dprintk(1, "%s()\n", __func__);
 
-#ifdef CONFIG_VIDEO_AU0828_RC
 	au0828_rc_unregister(dev);
-#endif
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
 
@@ -266,10 +264,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		pr_err("%s() au0282_dev_register failed\n",
 		       __func__);
 
-#ifdef CONFIG_VIDEO_AU0828_RC
 	/* Remote controller */
 	au0828_rc_register(dev);
-#endif
 
 	/*
 	 * Store the pointer to the au0828_dev so it can be accessed in
-- 
1.7.10.4

