Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3BSIMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:12:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab3BSIMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:12:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,693,1355068800"; 
   d="scan'208";a="6729000"
From: liguang <lig.fnst@cn.fujitsu.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] mips: remove unecessary __linux__ check
Date: Tue, 19 Feb 2013 16:12:51 +0800
Message-Id: <1361261571-1556-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 16:12:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 16:12:09,
	Serialize complete at 2013/02/19 16:12:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sgidefs.h has strict check for __linux__,
it seems too harsh, as far as I test, 2 cross
compiler for mips will not define it automatically,
and exit build process with error
"#error Use a Linux compiler or give up".
remove it will not hurt, I think.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/mips/include/uapi/asm/sgidefs.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/uapi/asm/sgidefs.h b/arch/mips/include/uapi/asm/sgidefs.h
index 876442f..5be81f8 100644
--- a/arch/mips/include/uapi/asm/sgidefs.h
+++ b/arch/mips/include/uapi/asm/sgidefs.h
@@ -11,14 +11,6 @@
 #define __ASM_SGIDEFS_H
 
 /*
- * Using a Linux compiler for building Linux seems logic but not to
- * everybody.
- */
-#ifndef __linux__
-#error Use a Linux compiler or give up.
-#endif
-
-/*
  * Definitions for the ISA levels
  *
  * With the introduction of MIPS32 / MIPS64 instruction sets definitions
-- 
1.7.2.5

