Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3LEWVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:21:36 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:8676
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762Ab3LEWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:21:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Emil Medve <Emilian.Medve@Freescale.com>
To: <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Emil Medve <Emilian.Medve@Freescale.com>
Subject: [PATCH] kbuild: Fix silent builds with make-4
Date: Thu, 5 Dec 2013 15:56:23 -0600
Message-ID: <1386280583-2735-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make-4 changed the way/order it presents the command line options
into MAKEFLAGS

In make-3.8x, '-s' would always be first into a group of options
with the '-'/hyphen removed

$ make -p -s 2>/dev/null | grep ^MAKEFLAGS
MAKEFLAGS = sp

In make-4, '-s' seems to always be last into a group of options
with the '-'/hyphen removed

$ make -s -p 2>/dev/null | grep ^MAKEFLAGS
MAKEFLAGS = ps

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index 2c88e44..0332949 100644
--- a/Makefile
+++ b/Makefile
@@ -311,9 +311,15 @@ endif
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
 
+ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
+ifneq ($(filter %s -s%,$(MAKEFLAGS)),)
+  quiet=silent_
+endif
+else					# make-3.8x
 ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
   quiet=silent_
 endif
+endif
 
 export quiet Q KBUILD_VERBOSE
 
-- 
1.8.5.1


