Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaJJHSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:18:44 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:38545 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbaJJHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:18:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMOALmHN1RXQw08/2dsb2JhbABggw6BK7deBQEBAQEBAQUBc5oWgQkXAXuEYCOBGjeIQgG0BI8LLIYgiiQdhDUFnUuWEYFHAWyBRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Dan Mick <dan.mick@inktank.com>, Fabian Frederick <fabf@skynet.be>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr
Subject: [PATCH 1/1 linux-next] scripts/coccinelle/misc/boolinit.cocci: fix assignment warnings
Date: Fri, 10 Oct 2014 09:18:31 +0200
Message-Id: <1412925511-3556-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "Assignment of bool to 0/1" by "Assignment of 0/1 to bool"

Suggested-by: Dan Mick <dan.mick@inktank.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/coccinelle/misc/boolinit.cocci | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/coccinelle/misc/boolinit.cocci b/scripts/coccinelle/misc/boolinit.cocci
index b9abed4..63c4562 100644
--- a/scripts/coccinelle/misc/boolinit.cocci
+++ b/scripts/coccinelle/misc/boolinit.cocci
@@ -145,13 +145,13 @@ cocci.print_main("WARNING: Comparison of bool to 0/1",p)
 p1 << r3.p1;
 @@
 
-cocci.print_main("WARNING: Assignment of bool to 0/1",p1)
+cocci.print_main("WARNING: Assignment of 0/1 to bool",p1)
 
 @script:python depends on org@
 p2 << r3.p2;
 @@
 
-cocci.print_main("ERROR: Assignment of bool to non-0/1 constant",p2)
+cocci.print_main("ERROR: Assignment of non-0/1 constant to bool",p2)
 
 @script:python depends on report@
 p << r1.p;
@@ -169,10 +169,10 @@ coccilib.report.print_report(p[0],"WARNING: Comparison of bool to 0/1")
 p1 << r3.p1;
 @@
 
-coccilib.report.print_report(p1[0],"WARNING: Assignment of bool to 0/1")
+coccilib.report.print_report(p1[0],"WARNING: Assignment of 0/1 to bool")
 
 @script:python depends on report@
 p2 << r3.p2;
 @@
 
-coccilib.report.print_report(p2[0],"ERROR: Assignment of bool to non-0/1 constant")
+coccilib.report.print_report(p2[0],"ERROR: Assignment of non-0/1 constant to bool")
-- 
1.9.3

