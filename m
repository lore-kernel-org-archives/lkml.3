Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaKQNnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:43:12 -0500
Received: from mout.web.de ([212.227.15.14]:52825 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaKQNnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:43:08 -0500
Message-ID: <5469FB58.4070205@users.sourceforge.net>
Date: Mon, 17 Nov 2014 14:42:48 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] tools lib traceevent: Deletion of an unnecessary check
 before the function call "free_arg"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:AD2GbVJvmOoOxIHrj4ey78bynPUxCB0ldkWhETX7eiYjmNOFw0o
 td+wqzVuBtFbhhFORpKMaLWCTxIIrYgYefgpQTKWjTrg3/+tmsF8oGFBtw4SH4XuQ2P3Vke
 +hQvvwAV4ue8KlYJWguiBg4ioBgza7Ysb09orEY6IaRKOLZ/hieR7Cm8vyStbHqtp8/KdCX
 Nn8MMzHACPA8hD/1XTygw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 14:38:14 +0100

The free_arg() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 tools/lib/traceevent/parse-filter.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index b502344..78debaf 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1237,8 +1237,7 @@ filter_event(struct event_filter *filter, struct event_format *event,
 	if (filter_type == NULL)
 		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
-	if (filter_type->filter)
-		free_arg(filter_type->filter);
+	free_arg(filter_type->filter);
 	filter_type->filter = arg;
 
 	return 0;
-- 
2.1.3

