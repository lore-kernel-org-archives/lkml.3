Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaENOxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:53:41 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57435 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaENOxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:53:40 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, russells@google.com, dmitriyz@google.com,
        git@xilinx.com, monstr@monstr.eu,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Fix uart0 early console virtual address
Date: Wed, 14 May 2014 16:53:29 +0200
Message-Id: <c2e5957287cc60655ac4cdd754bb34e874865d2a.1400079202.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12505-1400079209-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12505-1400079209-0001

Virtual address have to have the same offset within
a 2MB aligned section of virtual/phycial address space.

Fix uart0 virtual address to be align with physical one.
Also remove UART_SIZE which is completely unused.

Reported-by: Russ Smith <russells@google.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/include/debug/zynq.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/debug/zynq.S b/arch/arm/include/debug/zynq.S
index 0b762fafa758..3edfef7b34ae 100644
--- a/arch/arm/include/debug/zynq.S
+++ b/arch/arm/include/debug/zynq.S
@@ -20,18 +20,18 @@
 #define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty */

 #define UART0_PHYS		0xE0000000
+#define UART0_VIRT		0xF0000000
 #define UART1_PHYS		0xE0001000
-#define UART_SIZE		SZ_4K
-#define UART_VIRT		0xF0001000
+#define UART1_VIRT		0xF0001000

 #if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
 # define LL_UART_PADDR		UART1_PHYS
+# define LL_UART_VADDR		UART1_VIRT
 #else
 # define LL_UART_PADDR		UART0_PHYS
+# define LL_UART_VADDR		UART0_VIRT
 #endif

-#define LL_UART_VADDR		UART_VIRT
-
 		.macro	addruart, rp, rv, tmp
 		ldr	\rp, =LL_UART_PADDR	@ physical
 		ldr	\rv, =LL_UART_VADDR	@ virtual
--
1.8.2.3


--=_mimegpg-monstr-desktop-12505-1400079209-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNzg2kACgkQykllyylKDCE2UgCfYCQFQq+g9+17vyWW7Ka0jmDF
nGsAn3u1QzMPBzsiyCXBNR1EfjqkLQOw
=3w4S
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12505-1400079209-0001--
