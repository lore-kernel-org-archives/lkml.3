Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3CMDbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:31:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39996 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893Ab3CMD3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:29:36 -0400
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>, Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <lugo.fernando@gmail.com>
Subject: [PATCHv3 12/14] mailbox/omap: check iomem resource before dereferencing it
Date: Tue, 12 Mar 2013 22:24:28 -0500
Message-ID: <1363145068-14752-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a NULL check for iomem resource in mailbox probe functions.

Signed-off-by: Fernando Guzman Lugo <lugo.fernando@gmail.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/mailbox-omap1.c | 3 +++
 drivers/mailbox/mailbox-omap2.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 7b30157..4441872 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -179,6 +179,9 @@ static int omap1_mbox_probe(struct platform_device *pdev)
 	list[0]->irq = platform_get_irq_byname(pdev, "dsp");
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENOMEM;
+
 	mbox_base = ioremap(mem->start, resource_size(mem));
 	if (!mbox_base)
 		return -ENOMEM;
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 72f8368..eed5a3d 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -296,6 +296,11 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		ret = -ENOMEM;
+		goto free_privblk;
+	}
+
 	mbox_base = ioremap(mem->start, resource_size(mem));
 	if (!mbox_base) {
 		ret = -ENOMEM;
-- 
1.8.1.2

