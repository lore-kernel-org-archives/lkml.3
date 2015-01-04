Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbbADCPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 21:15:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34299 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbbADCP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 21:15:29 -0500
From: Daniel Tang <dt.tangr@gmail.com>
To: Peter.Chen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, Daniel Tang <dt.tangr@gmail.com>
Subject: [PATCH 2/2] Chipidea: Set connect-at-fullspeed bit when entering host mode if CI_HDRC_FORCE_FULLSPEED is set in the platform data
Date: Sun,  4 Jan 2015 13:14:59 +1100
Message-Id: <1420337699-28219-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420337699-28219-1-git-send-email-dt.tangr@gmail.com>
References: <1420337699-28219-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PORTSC_PFSC is not set on entering host mode which means the USB OTG
controller will attempt to enumerate USB devices at high speed even when the
CI_HDRC_FORCE_FULLSPEED flag is set in the platform data.

This patch ensures it is set right before host mode operations begin if needed.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/usb/chipidea/host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index c1694cf..f106d25 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -132,6 +132,9 @@ static int host_start(struct ci_hdrc *ci)
 	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
 		hw_write(ci, OP_USBMODE, USBMODE_CI_SDIS, USBMODE_CI_SDIS);
 
+	if (ci->platdata->flags & CI_HDRC_FORCE_FULLSPEED)
+		hw_write(ci, OP_PORTSC, PORTSC_PFSC, PORTSC_PFSC);
+
 	return ret;
 
 put_hcd:
-- 
2.1.3

