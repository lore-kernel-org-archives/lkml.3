Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3HVU0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:26:33 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50148 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3HVUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:44 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>, NeilBrown <neilb@suse.de>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH v2 3/5] raid6/test: replace echo -e with printf
Date: Fri, 23 Aug 2013 00:25:23 +0400
Message-Id: <1377203125-22934-4-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-e is a non-standard echo option, echo output is
implementation-dependent when it is used. Replace echo -e with printf as
suggested by POSIX echo manual.

Cc: NeilBrown <neilb@suse.de>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/raid6/test/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 087332d..73b0151 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -28,7 +28,7 @@ ifeq ($(IS_X86),yes)
                     gcc -c -x assembler - >&/dev/null &&	\
                     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
 else
-        HAS_ALTIVEC := $(shell echo -e '\#include <altivec.h>\nvector int a;' |\
+        HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
                          gcc -c -x c - >&/dev/null && \
                          rm ./-.o && echo yes)
         ifeq ($(HAS_ALTIVEC),yes)
-- 
1.7.7.6

