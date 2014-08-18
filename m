Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaHRLPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:15:37 -0400
Received: from mail.data-modul.de ([212.184.205.171]:25843 "HELO
	mailgw1.data-modul.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751372AbaHRLPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:15:36 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 07:15:35 EDT
From: Silvio Fricke <silvio.fricke@gmail.com>
To: "Yann E . MORIN" <yann.morin.1998@free.fr>
Cc: Silvio Fricke <silvio.fricke@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kconfig: menuconfig: pkg-config should base upon default configuration
Date: Mon, 18 Aug 2014 13:05:10 +0200
Message-Id: <1408359910-17394-2-git-send-email-silvio.fricke@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408359910-17394-1-git-send-email-silvio.fricke@gmail.com>
References: <1408359910-17394-1-git-send-email-silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fc9c6e0 "menuconfig: optionally use pkg-config to detect ncurses
libs" we use pkg-config, but some cross toolchains (like yocto tc)
change the search pathes for pc files with some PKG_CONFIG_* environment
variables.

With this patch we ensure that we only get the host config options for
ncurses and don't mix with others not relevant settings.

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 9d2a4c5..a067d3c 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -1,6 +1,9 @@
 #!/bin/sh
 # Check ncurses compatibility
 
+unset PKG_CONFIG_PATH
+unset PKG_CONFIG_SYSROOT_DIR
+
 # What library to link
 ldflags()
 {
-- 
2.0.4

