Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEWNWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:22:34 -0400
Received: from xvm-169-183.ghst.net ([95.142.169.183]:43341 "EHLO
	photon.sigxcpu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:22:33 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 09:22:32 EDT
Date: Fri, 23 May 2014 15:15:22 +0200
From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] genksyms: Include scripts/Makefile.lib
Message-ID: <20140523131522.GA25950@bogon.m.sigxcpu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise when building out of tree like

make V=1 O=/var/scratch/kernel/

it fails like

make -f /home/agx/linux/scripts/Makefile.build obj=scripts
make -f /home/agx/linux/scripts/Makefile.build obj=scripts/genksyms
(cat /dev/null; ) > scripts/genksyms/modules.order
  gcc -Wp,-MD,scripts/genksyms/.lex.lex.o.d -Iscripts/genksyms -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer  -I/home/agx/linux/scripts/genksyms -Iscripts/genksyms -c -o scripts/genksyms/lex.lex.o scripts/genksyms/lex.lex.c
scripts/genksyms/lex.lex.c_shipped:567:23: fatal error: parse.tab.h: No such file or directory
compilation terminated.
scripts/Makefile.host:134: recipe for target 'scripts/genksyms/lex.lex.o' failed
make[3]: *** [scripts/genksyms/lex.lex.o] Error 1
/home/agx/linux/scripts/Makefile.build:465: recipe for target 'scripts/genksyms' failed
make[2]: *** [scripts/genksyms] Error 2
/home/agx/linux/Makefile:542: recipe for target 'scripts' failed

Signed-off-by: Guido Günther <agx@sigxcpu.org>
---

I'm not sure wether this is the root cause and would be happy any
input on where to dig. GNU make is version 4.0.

 scripts/genksyms/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/genksyms/Makefile b/scripts/genksyms/Makefile
index aca33b9..1d86d14 100644
--- a/scripts/genksyms/Makefile
+++ b/scripts/genksyms/Makefile
@@ -1,3 +1,4 @@
+include scripts/Makefile.lib
 
 hostprogs-y	:= genksyms
 always		:= $(hostprogs-y)
-- 
2.0.0.rc0
