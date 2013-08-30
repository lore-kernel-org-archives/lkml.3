Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3H3ELE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:11:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42689 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3H3ELC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:11:02 -0400
X-Spam-Score: -100.9
Message-ID: <52201B15.6030905@asianux.com>
Date: Fri, 30 Aug 2013 12:09:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Zankel <chris@zankel.net>, Kees Cook <keescook@chromium.org>,
        Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: parport: Kconfig: exclude h8300 for PARPORT_PC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300 does not support PARPORT_PC.

The related error (with allmodconfig for h8300):

    CC [M]  drivers/parport/parport_pc.o
  drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/parport/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index dc82ef0..70694ce 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -37,7 +37,7 @@ config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
 		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
-		!XTENSA && !CRIS
+		!XTENSA && !CRIS && !H8300
 
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
-- 
1.7.7.6
