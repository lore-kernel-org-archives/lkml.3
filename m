Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3HLKYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:24:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:41 -0400
Date: Mon, 12 Aug 2013 03:24:22 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-cecb977e24da1465cdb0ff2d10d22e5891dc3e6c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1373936614-22224-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373936614-22224-1-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "tools lib lk: Fix for cross build"
Git-Commit-ID: cecb977e24da1465cdb0ff2d10d22e5891dc3e6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:24:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cecb977e24da1465cdb0ff2d10d22e5891dc3e6c
Gitweb:     http://git.kernel.org/tip/cecb977e24da1465cdb0ff2d10d22e5891dc3e6c
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 16 Jul 2013 10:03:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:41 -0300

Revert "tools lib lk: Fix for cross build"

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1373936614-22224-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile | 15 ---------------
 1 file changed, 15 deletions(-)

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
