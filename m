Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaKPKkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:40:41 -0500
Received: from mout.web.de ([212.227.15.14]:51633 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaKPKkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:40:39 -0500
Message-ID: <54687F1A.1010809@users.sourceforge.net>
Date: Sun, 16 Nov 2014 11:40:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check before
 the function call "audit_log_end"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zJiaU14hvZClCtukH77aZW1S4dUb+GyT1u4FCT7pg4Ob586lFJG
 983zNft4+eEmTcAXTzAcMWN4WMdM/0IurECZdA9qq3ofRhgrWCirKgOoZxsRq0uNiH8y7Lp
 PlmJ937TpVVwn896Cs20GCa2Yg2f9GOWca85B64PGMsd7yGDzz13n28+HJWAWPQJmwzsYDm
 vvZBj3s/MCNkPz133FPCA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 16 Nov 2014 11:27:43 +0100

The audit_log_end() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 kernel/auditsc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 21eae3c..1fed61c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1470,8 +1470,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
-	if (ab)
-		audit_log_end(ab);
+	audit_log_end(ab);
 	if (call_panic)
 		audit_panic("error converting sid to string");
 }
-- 
2.1.3


