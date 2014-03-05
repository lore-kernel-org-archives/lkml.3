Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaCEWsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:48:12 -0500
Received: from mout.web.de ([212.227.15.4]:55624 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaCEWsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:48:11 -0500
Message-ID: <5317A9A7.8080405@users.sourceforge.net>
Date: Wed, 05 Mar 2014 23:48:07 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org
Subject: Re: [coccicheck Linux 3.14-rc5 PATCH 1 of 5] Deletion of unnecessary
 checks before specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:0rp05vcUQBaXI88fv5S6NGhL/5fHGOFx4ESgjnK1bIxu90GwgKC
 4/Pk9wIjkctLy4QKrnmQACqJkimpJ45CbqMpOhZDXf0qfhdxRT8UoaNA3VpfRYGwMietO9j
 mTu+ujMX4zhlA8aTHlh/K+BwlLAgAMmo3We/qyFfgj7/0dpPG24IL8mfTT6BgIDLQvBdKE6
 PA0zysPV1VR+I6ljCVX3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

>From 48c9c4f61a7d7ea98538e02631a981a429281005 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Mar 2014 18:15:34 +0100
Subject: [PATCH 1/5] Addition of a semantic patch file for showing unnecessary
 checks before a few known functions

This semantic patch pattern tries to find source code places where a check
is performed for an expression that is passed to a function (like "kfree")
which checks this single parameter itself for usability.
Redundant value or pointer checks can be avoided here.

The pattern contains a special comment in a regular expression for a SmPL
constraint which supports extensions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 .../deletions/delete_unnecessary_checks_template1.cocci     | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644
scripts/coccinelle/deletions/delete_unnecessary_checks_template1.cocci

diff --git
a/scripts/coccinelle/deletions/delete_unnecessary_checks_template1.cocci
b/scripts/coccinelle/deletions/delete_unnecessary_checks_template1.cocci
new file mode 100644
index 0000000..b092051
--- /dev/null
+++ b/scripts/coccinelle/deletions/delete_unnecessary_checks_template1.cocci
@@ -0,0 +1,13 @@
+@Delete_unnecessary_checks@
+expression x;
+identifier release =~ "^(?x)
+(?:
+   (?:kz?|slob_)free
+|
+   (?:
+# Alternation placeholder
+   )
+)$";
+@@
+-if (x)
+    release(x);
-- 
1.9.0


