Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3KBPPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:15:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37140 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3KBPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:15:07 -0400
X-Originating-IP: 50.43.14.201
Date: Sat, 2 Nov 2013 08:15:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: [PATCHv2] coccinelle: Add a script to find unnecessary ifs with no
 body
Message-ID: <20131102151500.GW15704@leaf>
References: <20131102143236.GA18084@leaf>
 <alpine.DEB.2.02.1311021550330.2261@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311021550330.2261@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script finds code like this, with an unnecessary if:

if (foo) {}

Provides report mode only, since patching often eliminates conditionals
that contain TODO comments or similar.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v2: Drop patch mode.

 scripts/coccinelle/misc/unnecessary-if.cocci | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 scripts/coccinelle/misc/unnecessary-if.cocci

diff --git a/scripts/coccinelle/misc/unnecessary-if.cocci b/scripts/coccinelle/misc/unnecessary-if.cocci
new file mode 100644
index 0000000..28ac895
--- /dev/null
+++ b/scripts/coccinelle/misc/unnecessary-if.cocci
@@ -0,0 +1,23 @@
+/// Find unnecessary ifs with no statements.
+//
+// Report mode only, since patch mode often deletes ifs that contain TODO
+// comments.
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+
+virtual report
+virtual context
+
+@r depends on report || context@
+expression E;
+position p;
+@@
+if@p (E) {}
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "WARNING: Unnecessary if with no body."
+coccilib.report.print_report(p[0], msg)
-- 
1.8.4.2

