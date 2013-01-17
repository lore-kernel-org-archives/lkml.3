Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3AQDLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:11:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41786 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab3AQCyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:41 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 64/86] drivers/vhost: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:56 -0800
Message-Id: <1358391258-1771-65-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/vhost/Kconfig     |    4 ++--
 drivers/vhost/Kconfig.tcm |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 202bba6..bf24317 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,6 @@
 config VHOST_NET
-	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
-	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
+	tristate "Host kernel accelerator for virtio net"
+	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP)
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
index a9c6f76..7e3aa28 100644
--- a/drivers/vhost/Kconfig.tcm
+++ b/drivers/vhost/Kconfig.tcm
@@ -1,6 +1,6 @@
 config TCM_VHOST
-	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
-	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
+	tristate "TCM_VHOST fabric module"
+	depends on TARGET_CORE && EVENTFD && m
 	default n
 	---help---
 	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
-- 
1.7.9.5

