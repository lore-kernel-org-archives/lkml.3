Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaKPTS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:18:29 -0500
Received: from mout.web.de ([212.227.15.3]:64524 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaKPTS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:18:28 -0500
Message-ID: <5468F875.7080907@users.sourceforge.net>
Date: Sun, 16 Nov 2014 20:18:13 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH v2 1/2] kernel-trace: Deletion of an unnecessary check before
 the function call "iput"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5468ABBD.6000903@users.sourceforge.net> <alpine.DEB.2.10.1411161656340.2364@hadrien> <5468F756.8070807@users.sourceforge.net>
In-Reply-To: <5468F756.8070807@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:o9FTv+KrZK8PjSr/r7z+2+lhuJ9ZftUYwSBTiIqikrbhyNUln3b
 57ps07/uqsBXVvEZzArd/c5724sfARa/vKTF4N7oFMT9yxusqiWbXGphtlgOCy8X1rOyhPA
 twwyNJ6qKKpqwC9RKMgbNeEUMbanLrneW7VuRtjWRvnq3157L77LdtqU+Fldb0jjGMaXOiB
 7q0b8tui5iAqnMJ6ltYqw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 16 Nov 2014 14:46:28 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 kernel/trace/trace_uprobe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 33ff6a2..ec002c0 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -552,8 +552,7 @@ error:
 	return ret;
 
 fail_address_parse:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	pr_info("Failed to parse address or file.\n");
 
-- 
2.1.3


