Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3LJQiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:38:50 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:35347
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904Ab3LJQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:45 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MXLNF8-07-EIK-02
X-M-MSG: 
Subject: [PATCH 2/3] crypto: ccp - CCP Kconfig fixes
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 10:38:39 -0600
Message-ID: <20131210163838.24304.38541.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the Kconfig to include PCI on the 'depends on'
and add 'select HW_RANDOM' to insure the necessary PCI
and HW_RANDOM functions are available/included in the
build.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig     |    2 +-
 drivers/crypto/ccp/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4954d75..9dee00f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -401,7 +401,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on X86
+	depends on X86 && PCI
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 335ed5c..7639ffc 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -2,6 +2,7 @@ config CRYPTO_DEV_CCP_DD
 	tristate "Cryptographic Coprocessor device driver"
 	depends on CRYPTO_DEV_CCP
 	default m
+	select HW_RANDOM
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations


