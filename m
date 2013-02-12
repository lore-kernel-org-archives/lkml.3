Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3BLFDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:03:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab3BLFDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:14 -0500
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <greg@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>,
        Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <lugo.fernando@gmail.com>
Subject: [PATCH v2 11/13] mailbox/omap: check iomem resource before dereferencing it
Date: Mon, 11 Feb 2013 22:57:10 -0600
Message-ID: <1360645032-9668-12-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
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
index 295c32a..5b0f2c1 100644
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
index d3a3d84..9fbd491 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -293,6 +293,11 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
 	mbox_base = ioremap(mem->start, resource_size(mem));
 	if (!mbox_base) {
 		ret = -ENOMEM;
-- 
1.8.1.2

