Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaAFTeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:04 -0500
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:59622
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbaAFTeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:02 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVNQ-08-95R-02
X-M-MSG: 
Subject: [PATCH 0/6] crypto: ccp - more code fixes/cleanup
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:33:53 -0600
Message-ID: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a fix to hash length wrapping as well
as some additional fixes and cleanups (proper gfp_t type on some memory
allocations, scatterlist usage improvements, null request result field
checks and driver enabled/disabled changes).

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (6):
      crypto: ccp - Apply appropriate gfp_t type to memory allocations
      crypto: ccp - Cleanup scatterlist usage
      crypto: ccp - Check for caller result area before using it
      crypto: ccp - Change data length declarations to u64
      crypto: ccp - Cleanup hash invocation calls
      crypto: ccp - CCP device enabled/disabled changes


 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   38 +++++++++----
 drivers/crypto/ccp/ccp-crypto-sha.c      |   88 ++++++++++++++++++------------
 drivers/crypto/ccp/ccp-crypto.h          |   10 +++
 drivers/crypto/ccp/ccp-dev.c             |   15 +++++
 drivers/crypto/ccp/ccp-ops.c             |   34 ++++++------
 drivers/crypto/ccp/ccp-pci.c             |    3 +
 include/linux/ccp.h                      |   20 +++++--
 7 files changed, 139 insertions(+), 69 deletions(-)

-- 
Tom Lendacky

