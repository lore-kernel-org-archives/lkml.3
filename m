Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935092AbaH0PTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:19:35 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34797 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaH0PTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:19:34 -0400
From: Rob Clark <robdclark@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: maarten.lankhorst@canonical.com, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>
Subject: [PATCH] ww-mutex: clarify help text for DEBUG_WW_MUTEX_SLOWPATH
Date: Wed, 27 Aug 2014 11:19:26 -0400
Message-Id: <1409152766-31320-1-git-send-email-robdclark@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really don't want distro's enabling this in their kernels.  Try and
make that more clear.

Signed-off-by: Rob Clark <robdclark@gmail.com>
---
 lib/Kconfig.debug | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 07c2832..1b233fc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -892,6 +892,10 @@ config DEBUG_WW_MUTEX_SLOWPATH
 	 the full mutex checks enabled with (CONFIG_PROVE_LOCKING) this
 	 will test all possible w/w mutex interface abuse with the
 	 exception of simply not acquiring all the required locks.
+	 Note that this feature can introduce significant overhead, so
+	 it really should not be enabled in a production or distro kernel,
+	 even a debug kernel.  If you are a driver writer, enable it.  If
+	 you are a distro, do not.
 
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
-- 
1.9.3

