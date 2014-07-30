Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaG3MQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:16:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36823 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbaG3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 88/94] parisc: Remove SA_RESTORER define
Date: Wed, 30 Jul 2014 14:15:17 +0200
Message-Id: <f73273d2beb977a6aae15f698e06fc489e5d8e12.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 20dbea494543aefaace874cc3ec93a39b94b1ec4 upstream.

The sa_restorer field in struct sigaction is obsolete and no longer in
the parisc implementation.  However, the core code assumes the field is
present if SA_RESTORER is defined. So, the define needs to be removed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/parisc/include/uapi/asm/signal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/signal.h b/arch/parisc/include/uapi/asm/signal.h
index a2fa297196bc..f5645d6a89f2 100644
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
2.0.1

