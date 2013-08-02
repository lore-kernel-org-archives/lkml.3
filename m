Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3HBXlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:41:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3HBXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:41:09 -0400
Date: Fri, 2 Aug 2013 16:40:58 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dh.herrmann@gmail.com, hpa@linux.intel.com
In-Reply-To: <1375445127-15480-9-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-9-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: fbcon: select VT_HW_CONSOLE_BINDING
Git-Commit-ID: 765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:41:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92
Gitweb:     http://git.kernel.org/tip/765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:27 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:51 -0700

fbdev: fbcon: select VT_HW_CONSOLE_BINDING

fbdev provides framebuffer hotplugging, hence, we need to allow fbcon to
unbind from framebuffers. Unfortunately, fbcon_fb_unbind() cannot unbind
from the last framebuffer, unless console-unbinding is supported.

Fixing fbcon_unbind() to return 0 caused some horrible NULL-derefs in the
VT layer and I couldn't figure out why. Hence, lets just require
console-unbinding so fbdev hotplugging works with fbcon.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1375445127-15480-9-git-send-email-dh.herrmann@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/video/console/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 8c30603..846caab 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -92,7 +92,8 @@ config DUMMY_CONSOLE_ROWS
 
 config FRAMEBUFFER_CONSOLE
 	tristate "Framebuffer Console support"
-	depends on FB
+	depends on FB && !UML
+	select VT_HW_CONSOLE_BINDING
 	select CRC32
 	select FONT_SUPPORT
 	help
