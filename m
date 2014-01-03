Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaACQHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaACQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/7] Fix a defined-but-not-used warning for
 do_gma_backlight_set()
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Date: Fri, 03 Jan 2014 16:07:31 +0000
Message-ID: <20140103160731.8153.73224.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

	drivers/gpu/drm/gma500/backlight.c:29:13: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]

by moving the entire function inside the conditional section currently inside
of it.  All the places that call it are so conditionalised.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Alan Cox <alan@linux.intel.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/gpu/drm/gma500/backlight.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/backlight.c b/drivers/gpu/drm/gma500/backlight.c
index 143eba3309c5..d4f79bc3665e 100644
--- a/drivers/gpu/drm/gma500/backlight.c
+++ b/drivers/gpu/drm/gma500/backlight.c
@@ -26,13 +26,13 @@
 #include "intel_bios.h"
 #include "power.h"
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 static void do_gma_backlight_set(struct drm_device *dev)
 {
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	backlight_update_status(dev_priv->backlight_device);
-#endif	
 }
+#endif	
 
 void gma_backlight_enable(struct drm_device *dev)
 {

