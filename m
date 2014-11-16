Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaKPMeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:34:44 -0500
Received: from mout.web.de ([212.227.17.11]:62656 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbaKPMel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:34:41 -0500
Message-ID: <546899CF.8020808@users.sourceforge.net>
Date: Sun, 16 Nov 2014 13:34:23 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] kprobes: Deletion of an unnecessary check before the
 function call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:pZyvRpoZ8uGzQCbeHBdM3bgg7kVkbrkZoJ2VYfFw1Ug8yXHpMhH
 AJlBkwUnIhiUm7e3ravNmkK9E83KpvRUmVW4XCLgYj9ipMfxW6NXBgTqNbWGuaaYfIniJk/
 7+6UXNvnyrf9ZRiL3wVqR5X1TMaI+vnatl2cj188exLlGLig2+hl4Fn/Cu0Co15lt+AR1X5
 xNWdjcd6rB9cmbLM9y7Kw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 16 Nov 2014 12:20:31 +0100

The module_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 kernel/kprobes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f54..f1e7d45 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1527,8 +1527,7 @@ int register_kprobe(struct kprobe *p)
 out:
 	mutex_unlock(&kprobe_mutex);
 
-	if (probed_mod)
-		module_put(probed_mod);
+	module_put(probed_mod);
 
 	return ret;
 }
-- 
2.1.3


