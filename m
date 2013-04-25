Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab3DYRcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:32:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab3DYR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 17/21] X.509: do not emit any informational output
Date: Thu, 25 Apr 2013 19:29:00 +0200
Message-Id: <1366910944-3033663-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6JAVlzCCac8aXp2QCgbtVyF0P79cLG+GWxPdfG3UMJp
 SF1VdGdOtV9+k+9UhvXWmoZ4hmKdf6+JYb9sNiM6ixr0s5eNVL
 PtkQEMQmeAvBt+0Y8iIceYq5xbaENexb/hPRiHXalZkOaq8lRu
 sXxkePvdrauI32IfWIUvieL690blEkGuvKhcP2xCJFRNiLKrKq
 OY+WEIy/S2jBqm+RNkVESyG1Mab3CeiP15IAiTnc+mlUBoXSIP
 FNMrajWHY/l2mvVjMcDUrlmB8+rct8zalPuSLN1AY6r1W/ExAD
 mhsUY3o7nDOr8N4TEhYSX5kaLb7d+u8d5xw5AtzYiFUmLIOR5F
 110T78JN7Zd58GJYfoUTXkGlHSHOfcPM+i0hZ+POX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a kernel using 'make -s', I expect to see an empty output,
except for build warnings and errors. The build_OID_registry code
always prints one line when run, which is not helpful to most people
building the kernels, and which makes it harder to automatically
check for build warnings.

Let's just remove the one line output.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 lib/build_OID_registry | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/build_OID_registry b/lib/build_OID_registry
index dfbdaab..5d98272 100755
--- a/lib/build_OID_registry
+++ b/lib/build_OID_registry
@@ -50,8 +50,6 @@ my @indices = ();
 my @lengths = ();
 my $total_length = 0;
 
-print "Compiling ", $#names + 1, " OIDs\n";
-
 for (my $i = 0; $i <= $#names; $i++) {
     my $name = $names[$i];
     my $oid = $oids[$i];
-- 
1.8.1.2

