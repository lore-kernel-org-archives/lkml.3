Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbaF1Ry2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:54:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779AbaF1Rxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fathi Boudra <fathi.boudra@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.15 138/139] builddeb: use $OBJCOPY variable instead of objcopy
Date: Sat, 28 Jun 2014 10:48:19 -0700
Message-Id: <20140628174611.696734944@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/builddeb |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -155,11 +155,11 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_
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


