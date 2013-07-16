Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab3GPBDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:03:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50967 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3GPBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:03:36 -0400
X-AuditID: 9c930179-b7c49ae000000e68-29-51e49be68d75
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] Revert "tools lib lk: Fix for cross build"
Date: Tue, 16 Jul 2013 10:03:34 +0900
Message-Id: <1373936614-22224-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 079787f209416416383c74ea5d5044be2d586f5e.

Below commit already resolve a cross build problem.
I have been noticed this too lately.

    commit 3c4797d46c14fa0c7cf733a77bd4b28875078b53
    Author: Rabin Vincent <rabin@rab.in>
    Date:   Fri May 17 22:27:44 2013 +0200

    tools lib lk: Respect CROSS_COMPILE

    Make lk use CROSS_COMPILE, in order to be able to cross compile perf
    again.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 280dd82..3dba0a4 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -3,21 +3,6 @@ include ../../scripts/Makefile.include
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
-# Makefiles suck: This macro sets a default value of $(2) for the
-# variable named by $(1), unless the variable has been set by
-# environment or command line. This is necessary for CC and AR
-# because make sets default values, so the simpler ?= approach
-# won't work as expected.
-define allow-override
-  $(if $(or $(findstring environment,$(origin $(1))),\
-            $(findstring command line,$(origin $(1)))),,\
-    $(eval $(1) = $(2)))
-endef
-
-# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
-$(call allow-override,CC,$(CROSS_COMPILE)gcc)
-$(call allow-override,AR,$(CROSS_COMPILE)ar)
-
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
-- 
1.7.9.5

