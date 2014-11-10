Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaKJHRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:17:09 -0500
Received: from smtprelay.synopsys.com ([198.182.44.111]:41470 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKJHRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:17:07 -0500
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH] Makefile: allow building selected tests with non-NPTL toolchain
Date: Mon, 10 Nov 2014 10:16:54 +0300
Message-Id: <1415603814-7682-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures are still stuck with non-NPTL toolchains.
These are for example ARC, Blackfin, Xtensa etc.

Still rt-tests are very good benchmarks and it would be good to enable use of
at least selected (those that will be built) tests on those architectures.

This change makes it possible to only build subset of tests that don't require
NPTL calls.

By default behavior is not modified - all tests are built, but if one wants
to build with non-NPTL toolchain just add "HAVE_NPTL=no" in command line
or modify "HAVE_NPTL" variable right in Makefile and execute "make".

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Clark Williams <clark.williams@gmail.com>
---
 Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 318a5c6..675edf7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,13 @@
 VERSION_STRING = 0.89
 
-sources = cyclictest.c signaltest.c pi_stress.c rt-migrate-test.c	\
-	  ptsematest.c sigwaittest.c svsematest.c pmqtest.c sendme.c 	\
-	  pip_stress.c hackbench.c
+HAVE_NPTL ?= yes
+
+ifeq ($(HAVE_NPTL),yes)
+sources = cyclictest.c pi_stress.c pip_stress.c pmqtest.c rt-migrate-test.c
+endif
+
+sources += signaltest.c ptsematest.c sigwaittest.c svsematest.c sendme.c \
+	  hackbench.c
 
 TARGETS = $(sources:.c=)
 
-- 
1.9.3

