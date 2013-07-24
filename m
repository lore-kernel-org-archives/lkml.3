Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3GXNa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:30:27 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37676 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GXNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:30:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next] n_tty: Fix build breakage on ppc64
Date: Wed, 24 Jul 2013 09:30:05 -0400
Message-Id: <1374672605-12326-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130724144232.86d30134a8bc829b5172a5c2@canb.auug.org.au>
References: <20130724144232.86d30134a8bc829b5172a5c2@canb.auug.org.au>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
  'n_tty: Move buffers into n_tty_data'
broke the ppc64 build.

Include vmalloc.h for the required function declarations.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d8cf96a..dd8ae0c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -50,6 +50,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
+#include <linux/vmalloc.h>
 
 
 /* number of characters left in xmit buffer before select has we have room */
-- 
1.8.1.2

