Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3BLFDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:03:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34510 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab3BLFDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:30 -0500
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
Subject: [PATCH v2 12/13] mailbox: check for NULL nb in mailbox_put
Date: Mon, 11 Feb 2013 22:57:11 -0600
Message-ID: <1360645032-9668-13-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox_put function must check the notifier block for
NULL before trying to unregister it.

Signed-off-by: Fernando Guzman Lugo <lugo.fernando@gmail.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index eaaf87e..c38241a 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -473,7 +473,8 @@ EXPORT_SYMBOL(mailbox_get);
 
 void mailbox_put(struct mailbox *mbox, struct notifier_block *nb)
 {
-	blocking_notifier_chain_unregister(&mbox->notifier, nb);
+	if (nb)
+		blocking_notifier_chain_unregister(&mbox->notifier, nb);
 	mailbox_fini(mbox);
 }
 EXPORT_SYMBOL(mailbox_put);
-- 
1.8.1.2

