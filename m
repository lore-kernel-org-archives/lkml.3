Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3KLRjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:39:15 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:12761
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892Ab3KLRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:39:13 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VNB-07-DPL-02
X-M-MSG: 
Subject: [PATCH 00/10] AMD Cryptographic Coprocessor support
To: <davem@davemloft.net>, <linux-crytpo@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:39:01 -0600
Message-ID: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements support for the AMD Cryptographic
Coprocessor (CCP).  The AMD CCP provides hardware encryption, hashing
and other related operations.

This patch series is based on the 3.12 kernel.

---

Tom Lendacky (10):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: CCP device driver and interface support
      crypto: crypto API interface to the CCP device driver
      crypto: CCP AES crypto API support
      crypto: CCP AES CMAC mode crypto API support
      crypto: CCP XTS-AES crypto API support
      crypto: CCP SHA crypto API support
      crytpo: CCP device driver build files
      crypto: CCP maintainer information


 MAINTAINERS                              |    7 
 crypto/authenc.c                         |    7 
 drivers/crypto/Kconfig                   |   12 
 drivers/crypto/Makefile                  |    1 
 drivers/crypto/ccp/Kconfig               |   23 
 drivers/crypto/ccp/Makefile              |   10 
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |  355 +++++
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |  285 ++++
 drivers/crypto/ccp/ccp-crypto-aes.c      |  375 ++++++
 drivers/crypto/ccp/ccp-crypto-main.c     |  432 ++++++
 drivers/crypto/ccp/ccp-crypto-sha.c      |  497 +++++++
 drivers/crypto/ccp/ccp-crypto.h          |  191 +++
 drivers/crypto/ccp/ccp-dev.c             |  582 +++++++++
 drivers/crypto/ccp/ccp-dev.h             |  272 ++++
 drivers/crypto/ccp/ccp-ops.c             | 2020 ++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-pci.c             |  360 +++++
 include/crypto/scatterwalk.h             |    1 
 include/linux/ccp.h                      |  525 ++++++++
 18 files changed, 5952 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/ccp/Kconfig
 create mode 100644 drivers/crypto/ccp/Makefile
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-cmac.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-xts.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-main.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sha.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto.h
 create mode 100644 drivers/crypto/ccp/ccp-dev.c
 create mode 100644 drivers/crypto/ccp/ccp-dev.h
 create mode 100644 drivers/crypto/ccp/ccp-ops.c
 create mode 100644 drivers/crypto/ccp/ccp-pci.c
 create mode 100644 include/linux/ccp.h

-- 
Tom Lendacky

