Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaBXOmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:42:08 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:40979
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbaBXOmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:05 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchzz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1I8TV-08-O72-02
X-M-MSG: 
Subject: [PATCH 0/3] crypto: ccp - minor code fixes
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 08:41:56 -0600
Message-ID: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements some fixes to some code paths executed
during crypto API request processing.  These fixes address processing of
requests when the CCP driver returns -EBUSY and freeing memory in error
paths.

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (3):
      crypto: ccp - Prevent a possible lost CCP command request
      crypto: ccp - Invoke context callback when there is a backlog error
      crypto: ccp - Account for CCP backlog processing


 drivers/crypto/ccp/ccp-crypto-main.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

-- 
Tom Lendacky

