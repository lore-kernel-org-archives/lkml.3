Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab3FCWcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:32:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3FCWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:18 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=922NaX_6avMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=r1rNVV2mKzMA:10 a=7mOBRU54AAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=WeOa-AV5lc8A:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.220905113@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Helge Deller <deller@gmx.de>
Subject: [58/65] parisc: fix NATIVE set up in build
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0058-parisc-fix-NATIVE-set-up-in-build.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

[ Upstream commit 93782eba49e23c3f311a6b05a19ba15927ec4e8b ]

The ifeq operator does not accept globs, so this little bit of code will
never match (unless uname literally prints out "parsic*").  Rewrite to
use a pattern matching operator so that NATIVE is set to 1 on parisc.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 5707f1a..47cec3c 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -24,9 +24,7 @@ CHECKFLAGS	+= -D__hppa__=1
 LIBGCC		= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 MACHINE		:= $(shell uname -m)
-ifeq ($(MACHINE),parisc*)
-NATIVE		:= 1
-endif
+NATIVE		:= $(if $(filter parisc%,$(MACHINE)),1,0)
 
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
-- 
1.7.10.4


