Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbaKULqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:46:15 -0500
Received: from mout.web.de ([212.227.17.11]:58146 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062AbaKULqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:46:13 -0500
Message-ID: <546F25EE.5090601@users.sourceforge.net>
Date: Fri, 21 Nov 2014 12:45:50 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linuxppc-dev@lists.ozlabs.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] tty-hvsi_lib: Deletion of an unnecessary check before
 the function call "tty_kref_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:cY66m3KlxAS612GCdVW9z62h+kwqS+TZKTw/hT6S39TdXBVyJ+a
 N9J+su66zlUf7Qhe+X/i3tB83fd1pPgteApDYq/4rksdC9trm4EBME2O48u0kl+oXLB3EaA
 tew3rCIgKmU7Ah6xiA4XenYJGnE7Y5tNpAmnPbM0saqjnc+lgB28PiPGMWb5MOtWpO4gZbp
 zN8iwVDiKJ0E/QQSQcWcQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 12:40:32 +0100

The tty_kref_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/tty/hvc/hvsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 7ae6c29..a270f04 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -405,8 +405,7 @@ void hvsilib_close(struct hvsi_priv *pv, struct hvc_struct *hp)
 		hvsi_send_close(pv);
 	}
 
-	if (pv->tty)
-		tty_kref_put(pv->tty);
+	tty_kref_put(pv->tty);
 	pv->tty = NULL;
 }
 
-- 
2.1.3

