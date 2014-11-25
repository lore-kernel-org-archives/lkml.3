Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaKYAWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:22:00 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:49228 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaKYARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:17:32 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH V6 02/12] mailbox: Make struct mbox_controller's ops field const
Date: Mon, 24 Nov 2014 16:17:14 -0800
Message-Id: <1416874644-12070-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
References: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox controller's channel ops ought to be read-only.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
No changes from v5.
New for v5.
---
 include/linux/mailbox_controller.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index d4cf96f..68c4245 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -72,7 +72,7 @@ struct mbox_chan_ops {
  */
 struct mbox_controller {
 	struct device *dev;
-	struct mbox_chan_ops *ops;
+	const struct mbox_chan_ops *ops;
 	struct mbox_chan *chans;
 	int num_chans;
 	bool txdone_irq;
-- 
2.1.0.rc2.206.gedb03e5

