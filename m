Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3EQVj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:39:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3EQViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, Helge Deller <deller@gmx.de>
Subject: [ 099/102] parisc: fix NATIVE set up in build
Date: Fri, 17 May 2013 14:36:54 -0700
Message-Id: <20130517213254.683340701@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 93782eba49e23c3f311a6b05a19ba15927ec4e8b upstream.

The ifeq operator does not accept globs, so this little bit of code will
never match (unless uname literally prints out "parsic*").  Rewrite to
use a pattern matching operator so that NATIVE is set to 1 on parisc.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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


