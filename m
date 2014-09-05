Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaIEF2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:28:52 -0400
Received: from ozlabs.org ([103.22.144.67]:40824 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbaIEF2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:28:49 -0400
Message-ID: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
Subject: deb-pkg: Add support for powerpc little endian
From: Michael Neuling <mikey@neuling.org>
To: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kbuild@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Date: Fri, 05 Sep 2014 15:28:47 +1000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Debian powerpc little endian architecture is called ppc64le.  This
is the default architecture used by Ubuntu for powerpc.

The below checks the kernel config to see if we are compiling little
endian and sets the Debian arch appropriately.

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 35d5a58..6f4a1af 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -37,7 +37,7 @@ create_package() {
 	s390*)
 		debarch=s390$(grep -q CONFIG_64BIT=y $KCONFIG_CONFIG && echo x || true) ;;
 	ppc*)
-		debarch=powerpc ;;
+		debarch=$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo ppc64el || echo powerpc) ;;
 	parisc*)
 		debarch=hppa ;;
 	mips*)

