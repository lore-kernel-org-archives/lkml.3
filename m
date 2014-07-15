Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaGOVbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:31:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbaGOVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fathi Boudra <fathi.boudra@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/198] builddeb: use $OBJCOPY variable instead of objcopy
Date: Tue, 15 Jul 2014 14:28:07 -0700
Message-Id: <1405459868-15089-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fathi Boudra <fathi.boudra@linaro.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 scripts/package/builddeb | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c1bb9be..6d02fd5d 100644
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
1.9.1

