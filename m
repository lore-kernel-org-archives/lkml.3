Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3BYMzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:55:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759189Ab3BYMzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:55:18 -0500
From: Michal Marek <mmarek@suse.cz>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.grzeschik@pengutronix.de
Subject: [PATCH] kbuild: Fix reading of .config in link-vmlinux.sh
Date: Mon, 25 Feb 2013 13:54:58 +0100
Message-Id: <1361796898-19642-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
References: <20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shell '.' command is not required to search the current directory as
a fallback and in fact newer versions of bash in sh-mode do not do this.
Force reading the file from the current directory if $KCONFIG_CONFIG
contains no '/'.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/link-vmlinux.sh |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e62f1e0..3d569d6 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -132,7 +132,14 @@ if [ "$1" = "clean" ]; then
 fi
 
 # We need access to CONFIG_ symbols
-. ${KCONFIG_CONFIG}
+case "${KCONFIG_CONFIG}" in
+*/*)
+	. "${KCONFIG_CONFIG}"
+	;;
+*)
+	# Force using a file from the current directory
+	. "./${KCONFIG_CONFIG}"
+esac
 
 #link vmlinux.o
 info LD vmlinux.o
-- 
1.7.10.4

