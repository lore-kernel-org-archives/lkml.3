Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbaEQPA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:00:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:50151 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043AbaEQPAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:00:25 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] fs: Cleanup string initializations (char[] instead of char *)
Date: Sat, 17 May 2014 17:00:18 +0200
Message-Id: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:JXDOKDH0qttY3PC6J9EqkMJVU0VnSWQ82SwjDmGuMMI4xGekLHa
 rr2rosHeRNvoUtcRVb2fTSxssJpv3QqnjUfbTWj2zTAMsZ30iR7kRtUpUJMBFh0vKCzKseH
 9gOFKAx6ndSa1sgI27+WTazUqpOguQtPG104ksgQHheXIEeuBPvg/RkxoSIdwiMzncoWsFq
 a/gT/Dcm3/qY84RKyyakA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializations like 'char *foo = "bar"' will create two variables: a static
string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
will declare a single variable and will end up in shorter
assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b605003..2a10529 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -419,7 +419,7 @@ static void entry_status(Node *e, char *page)
 {
 	char *dp;
 	char *status = "disabled";
-	const char * flags = "flags: ";
+	const char flags[] = "flags: ";
 
 	if (test_bit(Enabled, &e->flags))
 		status = "enabled";
-- 
1.7.10.4

