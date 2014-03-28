Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaC1Rix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaC1RbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.13 25/46] deb-pkg: Fix building for MIPS big-endian or ARM OABI
Date: Fri, 28 Mar 2014 10:32:09 -0700
Message-Id: <20140328173138.052732499@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c5e318f67eebbad491615a752c51dbfde7dc3d78 upstream.

These commands will mysteriously fail:

$ make ARCH=arm versatile_defconfig
[...]
$ make ARCH=arm deb-pkg
[...]
make[1]: *** [deb-pkg] Error 1
make: *** [deb-pkg] Error 2

The Debian architecture selection for these kernel architectures does
'grep FOO=y $KCONFIG_CONFIG && echo bar', and after 'set -e' this
aborts the script if grep does not find the given config symbol.

Fixes: 10f26fa64200 ('build, deb-pkg: select userland architecture based on UTS_MACHINE')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/builddeb |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -41,9 +41,9 @@ create_package() {
 	parisc*)
 		debarch=hppa ;;
 	mips*)
-		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo el) ;;
+		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo el || true) ;;
 	arm*)
-		debarch=arm$(grep -q CONFIG_AEABI=y $KCONFIG_CONFIG && echo el) ;;
+		debarch=arm$(grep -q CONFIG_AEABI=y $KCONFIG_CONFIG && echo el || true) ;;
 	*)
 		echo "" >&2
 		echo "** ** **  WARNING  ** ** **" >&2


