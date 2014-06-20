Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966600AbaFTSbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:31:52 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41977 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbaFTSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:31:50 -0400
X-IronPort-AV: E=Sophos;i="5.01,515,1400050800"; 
   d="scan'208";a="35193162"
From: Markus Mayer <markus.mayer@linaro.org>
To: Michal Marek <mmarek@suse.cz>
CC: Linux Build List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/2] Makefile: Make HOSTCFLAGS and HOSTCXXFLAGS user modifyable
Date: Fri, 20 Jun 2014 11:31:28 -0700
Message-ID: <1403289089-11299-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
References: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow the user to pass extra arguments to the host
compiler, we no longer overwrite the host compiler flags in the
makefile, but append them to what was passed in.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 97b2861..5795eea 100644
--- a/Makefile
+++ b/Makefile
@@ -251,8 +251,8 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 
 HOSTCC       = gcc
 HOSTCXX      = g++
-HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
-HOSTCXXFLAGS = -O2
+HOSTCFLAGS   += -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
+HOSTCXXFLAGS += -O2
 
 ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
 HOSTCFLAGS  += -Wno-unused-value -Wno-unused-parameter \
-- 
1.9.1

