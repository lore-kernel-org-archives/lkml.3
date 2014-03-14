Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaCNW7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:59:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaCNW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:58:59 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-m32r@ml.linux-m32r.org, microblaze-uclinux@itee.uq.edu.au,
        linux-am33-list@redhat.com
Subject: [PATCH 2/2] Cleanup useless architecture versions of scatterlist.h
Date: Fri, 14 Mar 2014 15:58:50 -0700
Message-Id: <1394837930-27731-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1394837930-27731-1-git-send-email-lauraa@codeaurora.org>
References: <1394837930-27731-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to have an architecture version of scatterlist.h
if the only thing the file does is include asm-generic/scatterlist.h.
Switch to the asm-generic versions directly.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>,
Cc: Michal Simek <monstr@monstr.eu>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Chen Liqin <liqin.linux@gmail.com>,
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/alpha/include/asm/Kbuild             |  1 +
 arch/alpha/include/asm/scatterlist.h      |  6 ------
 arch/cris/include/asm/Kbuild              |  1 +
 arch/cris/include/asm/scatterlist.h       |  6 ------
 arch/frv/include/asm/Kbuild               |  1 +
 arch/frv/include/asm/scatterlist.h        |  6 ------
 arch/m32r/include/asm/Kbuild              |  1 +
 arch/m32r/include/asm/scatterlist.h       |  6 ------
 arch/microblaze/include/asm/Kbuild        |  1 +
 arch/microblaze/include/asm/scatterlist.h |  1 -
 arch/mn10300/include/asm/Kbuild           |  1 +
 arch/mn10300/include/asm/scatterlist.h    | 16 ----------------
 arch/score/include/asm/Kbuild             |  2 +-
 arch/score/include/asm/scatterlist.h      |  6 ------
 14 files changed, 7 insertions(+), 48 deletions(-)
 delete mode 100644 arch/alpha/include/asm/scatterlist.h
 delete mode 100644 arch/cris/include/asm/scatterlist.h
 delete mode 100644 arch/frv/include/asm/scatterlist.h
 delete mode 100644 arch/m32r/include/asm/scatterlist.h
 delete mode 100644 arch/microblaze/include/asm/scatterlist.h
 delete mode 100644 arch/mn10300/include/asm/scatterlist.h
 delete mode 100644 arch/score/include/asm/scatterlist.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a73a8e2..2eeb6f2 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff --git a/arch/alpha/include/asm/scatterlist.h b/arch/alpha/include/asm/scatterlist.h
deleted file mode 100644
index 017d747..0000000
--- a/arch/alpha/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ALPHA_SCATTERLIST_H
-#define _ALPHA_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(_ALPHA_SCATTERLIST_H) */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index f3fd876..d9e86c7 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -14,3 +14,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += scatterlist.h
diff --git a/arch/cris/include/asm/scatterlist.h b/arch/cris/include/asm/scatterlist.h
deleted file mode 100644
index f11f8f4..0000000
--- a/arch/cris/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_CRIS_SCATTERLIST_H
-#define __ASM_CRIS_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(__ASM_CRIS_SCATTERLIST_H) */
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index bc42f14..5ccdc46 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff --git a/arch/frv/include/asm/scatterlist.h b/arch/frv/include/asm/scatterlist.h
deleted file mode 100644
index 0e5eb30..0000000
--- a/arch/frv/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !_ASM_SCATTERLIST_H */
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 932435a..8672b27 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
diff --git a/arch/m32r/include/asm/scatterlist.h b/arch/m32r/include/asm/scatterlist.h
deleted file mode 100644
index 7370b8b..0000000
--- a/arch/m32r/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_SCATTERLIST_H
-#define _ASM_M32R_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_M32R_SCATTERLIST_H */
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 2b98bc7..9270f69 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += trace_clock.h
+generic-y += scatterlist.h
 generic-y += syscalls.h
 generic-y += preempt.h
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
deleted file mode 100644
index 35d786f..0000000
--- a/arch/microblaze/include/asm/scatterlist.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/scatterlist.h>
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 992e989..3045ffe 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,5 +3,6 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
diff --git a/arch/mn10300/include/asm/scatterlist.h b/arch/mn10300/include/asm/scatterlist.h
deleted file mode 100644
index 7baa400..0000000
--- a/arch/mn10300/include/asm/scatterlist.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* MN10300 Scatterlist definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_SCATTERLIST_H */
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 146b9d5..62d35f1 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -7,4 +7,4 @@ generic-y += hash.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
-
+generic-y += scatterlist.h
diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
deleted file mode 100644
index 9f533b8..0000000
--- a/arch/score/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SCATTERLIST_H
-#define _ASM_SCORE_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_SCORE_SCATTERLIST_H */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

