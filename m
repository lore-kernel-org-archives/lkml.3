Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbaFQTol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:44:41 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:56305 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933009AbaFQTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:44:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJABCaoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ4XdYRgI4EaN4hGActZhWOJEx2ELQSaQ5NYg0I7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree test
Date: Tue, 17 Jun 2014 21:43:19 +0200
Message-Id: <1403034199-9824-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a trivial script warning on

if(foo)
	kfree(foo)

(based on checkpatch)

Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/coccinelle/free/cond_kfree.cocci | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 scripts/coccinelle/free/cond_kfree.cocci

diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
new file mode 100644
index 0000000..0b8093e
--- /dev/null
+++ b/scripts/coccinelle/free/cond_kfree.cocci
@@ -0,0 +1,34 @@
+/// conditional kfree - NULL check before kfree is not needed.
+///
+/// Based on checkpatch warning
+/// "kfree(NULL) is safe this check is probably not required"
+/// and kfreeaddr.cocci by Julia Lawall.
+///
+/// Comments: -
+/// Options: --no-includes --include-headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || report || org @
+expression E;
+position p;
+@@
+
+* if (E)
+*	kfree@p(E);
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("kfree", p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "WARNING: checking value to avoid kfree(NULL) is unnecessary."
+coccilib.report.print_report(p[0], msg)
+
-- 
1.8.4.5

