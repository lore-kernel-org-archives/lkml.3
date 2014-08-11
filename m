Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaHKFmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:42:43 -0400
Received: from bes.se.axis.com ([195.60.68.10]:50095 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaHKFmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:42:40 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>, David Howells <dhowells@redhat.com>
Date: Mon, 11 Aug 2014 07:35:15 +0200
Subject: RE: [PATCH 01/38] cris: fix headers_install
Thread-Topic: [PATCH 01/38] cris: fix headers_install
Thread-Index: Ac+fdZeiLngCjyyVSRyMMcIkyQwQhAVsGzMA
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0589EBFBC0FB@xmail3.se.axis.com>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice!

Acked-by: Mikael Starvik <mikael.starvik@axis.com>

-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: den 14 juli 2014 17:08
To: Arnd Bergmann
Cc: lkml; linux-arch; Sam Ravnborg; Mikael Starvik; Jesper Nilsson; David Howells
Subject: [PATCH 01/38] cris: fix headers_install

Fix headers_install by adjusting the path to arch files.
And delete unused Kbuild file.
Drop special handling of cris in the headers.sh script as a nice side-effect.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/cris/include/asm/Kbuild      | 5 -----
 arch/cris/include/uapi/asm/Kbuild | 4 ++--
 scripts/headers.sh                | 2 --
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild index afff510..35574f5 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -1,8 +1,3 @@
-
-header-y += arch-v10/
-header-y += arch-v32/
-
-
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index 7d47b36..01f66b8 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -1,8 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += arch-v10/
-header-y += arch-v32/
+header-y += ../arch-v10/arch/
+header-y += ../arch-v32/arch/
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/scripts/headers.sh b/scripts/headers.sh index 95ece06..d4dc4de 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -19,8 +19,6 @@ for arch in ${archs}; do
 	case ${arch} in
 	um)        # no userspace export
 		;;
-	cris)      # headers export are known broken
-		;;
 	*)
 		if [ -d ${srctree}/arch/${arch} ]; then
 			do_command $1 ${arch}
--
1.9.3

