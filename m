Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbaE3UQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:16:32 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50322 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030266AbaE3UFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 06/32] isofs: fix timestamps beyond 2027
Date: Fri, 30 May 2014 22:01:30 +0200
Message-Id: <1401480116-1973111-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dEYKnO6oSDMHKTJg9WJNLRPad6u3U9SijQ8PiYW6MNw
 1+QCvlddesXeh43lZ3Lfb8iWW7UTrbsjkBcGpAM8a7LI/uX2ca
 Mhe+1kXfOZtzGPHNXB1j7EvX9CPZdHakVtQH6imcBtUUUIdFui
 jp+uFhUaAbhvKYtLj8b6dmWnwmPoDVBmL8isw9R+8aMGKh7wmk
 IuJPKx6O5QaqUXhIyBjx55zq4j1PmGPZoXdfHu+VyLDMZKa+6y
 FZBKyy71RuVlVozGT77TpsE3i2laQ2R9KlMzoHBg4jDABhf7cQ
 ZlfLSCi8B1pexgJrVfOoClQFDfsSKc3bZWKqihCX93PVXdOVeB
 hfm9LLBjc2K8Bskxw41ktbuKC3wY2lazQHdMtxflc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isofs uses a 'char' variable to load the number of years since
1900 for an inode timestamp. On architectures that use a signed
char type by default, this results in an invalid date for
anything beyond 2027.

This adds a cast to 'u8' for the year number, which should extend
the shelf life of the file system until 2155.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/isofs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index 01e1ee7..28e7ff1 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -19,7 +19,7 @@ int iso_date(char * p, int flag)
 	int year, month, day, hour, minute, second, tz;
 	int crtime, days, i;
 
-	year = p[0] - 70;
+	year = (int)(u8)p[0] - 70;
 	month = p[1];
 	day = p[2];
 	hour = p[3];
-- 
1.8.3.2

