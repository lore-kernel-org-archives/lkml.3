Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3FLLUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:20:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:19517 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab3FLLUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,851,1363158000"; 
   d="scan'208";a="348650142"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v2 net-next 1/3] net: remove NET_LL_RX_POLL config menue
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 12 Jun 2013 14:19:55 +0300
Message-ID: <20130612111955.19288.12053.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130612111942.19288.12131.stgit@ladj378.jer.intel.com>
References: <20130612111942.19288.12131.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NET_LL_RX_POLL from the config menu.
Change default to y.
Busy polling still needs to be enabled at run time.

Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 net/Kconfig |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index d6a9ce6..8fe8845 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -244,16 +244,9 @@ config NETPRIO_CGROUP
 	  a per-interface basis
 
 config NET_LL_RX_POLL
-	bool "Low Latency Receive Poll"
+	boolean
 	depends on X86_TSC
-	default n
-	---help---
-	  Support Low Latency Receive Queue Poll.
-	  (For network card drivers which support this option.)
-	  When waiting for data in read or poll call directly into the the device driver
-	  to flush packets which may be pending on the device queues into the stack.
-
-	  If unsure, say N.
+	default y
 
 config BQL
 	boolean

