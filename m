Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3D3Umh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:42:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307Ab3D3Umf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:42:35 -0400
Date: Tue, 30 Apr 2013 22:42:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dummy-irq: require the user to specify an IRQ number
In-Reply-To: <20130430072817.61d3ca9f@lwn.net>
Message-ID: <alpine.LNX.2.00.1304302240390.20139@pobox.suse.cz>
References: <20130429211605.GA4102@redhat.com> <alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz> <20130430072817.61d3ca9f@lwn.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] dummy-irq: require the user to specify an IRQ number

Make sure that we let the user know that without specifying IRQ#, 
dummy-irq driver is useless.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/misc/dummy-irq.c b/drivers/misc/dummy-irq.c
index 7014167..c37eeed 100644
--- a/drivers/misc/dummy-irq.c
+++ b/drivers/misc/dummy-irq.c
@@ -19,7 +19,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-static int irq;
+static int irq = -1;
 
 static irqreturn_t dummy_interrupt(int irq, void *dev_id)
 {
@@ -36,6 +36,10 @@ static irqreturn_t dummy_interrupt(int irq, void *dev_id)
 
 static int __init dummy_irq_init(void)
 {
+	if (irq < 0) {
+		printk(KERN_ERR "dummy-irq: no IRQ given.  Use irq=N\n");
+		return -EIO;
+	}
 	if (request_irq(irq, &dummy_interrupt, IRQF_SHARED, "dummy_irq", &irq)) {
 		printk(KERN_ERR "dummy-irq: cannot register IRQ %d\n", irq);
 		return -EIO;
-- 
Jiri Kosina
SUSE Labs
