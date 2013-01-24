Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3AXPXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:23:19 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55356 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3AXPXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:23:17 -0500
From: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rkmahefa@gmail.com
Subject: [PATCH] scripts: kconfig: qconf.cc: fix a compiliation error when using make xconfig
Date: Thu, 24 Jan 2013 16:20:39 +0000
Message-Id: <1359044439-13647-1-git-send-email-rkmahefa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 janvier 2013 à 11:36:31, Michal Marek a écrit :
> On 16.1.2013 13:26, Tiana Rakotovao Andriamahefa wrote:
> > I have checked it and found that the error was effectively fixed in the last
> > maintained upload of Qt3 in 2011. However, the correction is not yet in Wheezy
> > (Debian testing) which I have used for more than a year. It might be
> > included there one day!
> > This is the case of Debian, but not all distros.
> 
> OK. And it is dead upstream. So I'll apply your patch. Could you please
> resend it? I deleted the email already.

Here is the patch.

When using make xconfig, the following compilation error appears :
   /usr/include/qt3/qvaluelist.h:427:13: error: ‘ptrdiff_t’ does not name a type
Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.

Signed-off-by: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
---
 scripts/kconfig/qconf.cc |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index df274fe..1500c38 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -6,6 +6,7 @@
 #include <qglobal.h>
 
 #if QT_VERSION < 0x040000
+#include <stddef.h>
 #include <qmainwindow.h>
 #include <qvbox.h>
 #include <qvaluelist.h>
-- 
1.7.10.4

