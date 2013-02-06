Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3BFSPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:15:12 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:60868 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3BFSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:15:10 -0500
Date: Wed, 6 Feb 2013 10:15:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: liguang <lig.fnst@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: break circular include from linux/mmzone.h fix fix fix
 fix
In-Reply-To: <1360037707-13935-1-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302061013160.26828@chino.kir.corp.google.com>
References: <1360037707-13935-1-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-853465630-1360174509=:26828"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-853465630-1360174509=:26828
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

kernel/jump_label.c: In function ‘jump_label_module_notify’:
kernel/jump_label.c:393:2: error: implicit declaration of function ‘notifier_from_errno’ [-Werror=implicit-function-declaration]
kernel/jump_label.c: At top level:
kernel/jump_label.c:396:8: error: variable ‘jump_label_module_nb’ has initializer but incomplete type
kernel/jump_label.c:397:2: error: unknown field ‘notifier_call’ specified in initializer
kernel/jump_label.c:397:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:397:2: warning: (near initialization for ‘jump_label_module_nb’) [enabled by default]
kernel/jump_label.c:398:2: error: unknown field ‘priority’ specified in initializer
kernel/jump_label.c:398:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:398:2: warning: (near initialization for ‘jump_label_module_nb’) [enabled by default]

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/jump_label.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 60f48fa..012219d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/notifier.h>
 
 #ifdef HAVE_JUMP_LABEL
 
--531381512-853465630-1360174509=:26828--
