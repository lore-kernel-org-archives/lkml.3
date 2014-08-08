Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbaHHW2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:28:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbaHHUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 174/259] parisc: Remove SA_RESTORER define
Date: Fri,  8 Aug 2014 13:39:57 -0700
Message-Id: <1407530482-4483-175-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 20dbea494543aefaace874cc3ec93a39b94b1ec4 upstream.

The sa_restorer field in struct sigaction is obsolete and no longer in
the parisc implementation.  However, the core code assumes the field is
present if SA_RESTORER is defined. So, the define needs to be removed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/include/uapi/asm/signal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/signal.h b/arch/parisc/include/uapi/asm/signal.h
index a2fa2971..f5645d6 100644
--- a/arch/parisc/include/uapi/asm/signal.h
+++ b/arch/parisc/include/uapi/asm/signal.h
@@ -69,8 +69,6 @@
 #define SA_NOMASK	SA_NODEFER
 #define SA_ONESHOT	SA_RESETHAND
 
-#define SA_RESTORER	0x04000000 /* obsolete -- ignored */
-
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-- 
1.9.1

