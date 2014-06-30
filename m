Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaF3Mai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbaF3Maf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fathi Boudra <fathi.boudra@linaro.org>,
        Michal Marek <mmarek@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 177/181] builddeb: use $OBJCOPY variable instead of objcopy
Date: Mon, 30 Jun 2014 13:53:18 +0200
Message-Id: <56044e30eaf5fd87562183b0b7c5e6697e61caf8.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fathi Boudra <fathi.boudra@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6b4a144a92ab81a1f45fb9b12aebaaaee0d08120 upstream.

In cross-build environment, we expect to use the cross-compiler objcopy
instead of the host objcopy.

It fixes following build failures:
objcopy --only-keep-debug lib/modules/3.14/kernel/net/ipv6/xfrm6_mode_tunnel.ko /srv/build/linux/debian/dbgtmp/usr/lib/debug/lib/modules/3.14/kernel/net/ipv6/xfrm6_mode_tunnel.ko
objcopy: Unable to recognise the format of the input file `lib/modules/3.14/kernel/net/ipv6/xfrm6_mode_tunnel.ko'

Signed-off-by: Fathi Boudra <fathi.boudra@linaro.org>
Fixes: 810e843746b7 ('deb-pkg: split debug symbols in their own package')
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 scripts/package/builddeb | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c1bb9be00fa0..6d02fd5d59bd 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -155,11 +155,11 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
 			for module in $(find lib/modules/ -name *.ko); do
 				mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
 				# only keep debug symbols in the debug file
-				objcopy --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
+				$OBJCOPY --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
 				# strip original module from debug symbols
-				objcopy --strip-debug $module
+				$OBJCOPY --strip-debug $module
 				# then add a link to those
-				objcopy --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
+				$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
 			done
 		)
 	fi
-- 
2.0.0

