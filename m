Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaFKP6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:58:25 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39136 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaFKP6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:58:23 -0400
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        akpm@linux-foundation.org
Cc: geert@linux-m68k.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH 1/1] security: Used macros from compiler.h instead of __attribute__((...))
Date: Wed, 11 Jun 2014 21:25:30 +0530
Message-Id: <1402502130-26400-2-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402502130-26400-1-git-send-email-gidisrael@gmail.com>
References: <1402502130-26400-1-git-send-email-gidisrael@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __packed
for __attribute__((packed)).

This patch is part of a large task I've taken to clean the gcc
specific attributes and use the the macros instead.

Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
---
 security/selinux/include/security.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index ce7852c..ff19bcc 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -8,6 +8,7 @@
 #ifndef _SELINUX_SECURITY_H_
 #define _SELINUX_SECURITY_H_
 
+#include <linux/compiler.h>
 #include <linux/dcache.h>
 #include <linux/magic.h>
 #include <linux/types.h>
@@ -220,7 +221,7 @@ struct selinux_kernel_status {
 	/*
 	 * The version > 0 supports above members.
 	 */
-} __attribute__((packed));
+} __packed;
 
 extern void selinux_status_update_setenforce(int enforcing);
 extern void selinux_status_update_policyload(int seqno);
-- 
1.9.3

