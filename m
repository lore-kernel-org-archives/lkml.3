Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaCEVH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:07:27 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:43351
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755769AbaCEVHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:07:19 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZENQ-08-66O-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/3] amd/pci: Add AMD hostbridge supports for newer AMD systems
Date: Wed, 5 Mar 2014 15:06:40 -0600
Message-ID: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

The current code only supports upto AMD hostbridge for family11h.
This causes PCI numa_node information to be reported incorrectly
for newer family with multi sockets.

This patch set introduces the logic to discover AMD hostbridges.

Note: 
    * Patch 1 and 2 are functional changes.
    * Patch 3 is code clean up/restructuring

Suravee Suthikulpanit (3):
  amd/pci: Add supports for generic AMD hostbridges
  amd/pci: Support additional MMIO ranges capabilities
  amd/pci: Miscellaneous code clean up for early_fillup_mp_bus_info

 arch/x86/pci/amd_bus.c |  376 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 251 insertions(+), 125 deletions(-)

-- 
1.7.10.4


