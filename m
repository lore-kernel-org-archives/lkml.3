Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFCJyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:54:35 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58241 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFCJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:54:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Joe Perches <joe@perches.com>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] serial: samsung: fix typo in debug code
Date: Tue, 03 Jun 2014 11:53:47 +0200
Message-ID: <10455941.RzodM59Z3O@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8aTxr+ACTn1tkSqPNasw4Ivwn3KhRiI9U7jLYuJ0kQ2
 QmMPLvS0IQ86UMcRlA6jwVrybtEMu1cFLvoCzxD25stPsFLSGS
 SLv38+ybFubwTKRCPJddCyGLvTvHR+EI3ctrpLMvazAbtkNDGY
 VJqfps8xT83BCnUny5Ezn4tpW59SIzgOkr6tbOkdChjvEUdw9f
 k3mUuca8iABllDcCrC04FNNKkQvTGqQd1rzcEgQeWf8rohvCz2
 1VteKbbF2fOHQd49k0MxSN/K/248bEttvRwC3yfzDIeYYTccT6
 27QuYpTQPZODczOIeT7NykrAVRrxy7UJsPtACOJIKePoBj+hGu
 7QnK8StMUOYXUUZNNmG8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e4ac92df2791 ("serial: samsung: Neaten dbg uses") introduced
a regression in the conversion from vsprintf to vsnprintf.

This fixes the build error by passing the correct variable name.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 3293377..c1d3ebd 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -66,7 +66,7 @@ static void dbg(const char *fmt, ...)
 	char buff[256];
 
 	va_start(va, fmt);
-	vscnprintf(buff, sizeof(buf), fmt, va);
+	vscnprintf(buff, sizeof(buff), fmt, va);
 	va_end(va);
 
 	printascii(buff);

