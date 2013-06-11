Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3FKOYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:24:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:1594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab3FKOYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="327707957"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH net-next 1/2] net: remove NET_LL_RX_POLL config menue
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
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 11 Jun 2013 17:24:28 +0300
Message-ID: <20130611142428.17879.33582.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NET_LL_RX_POLL from the config menu.
Change default to y.
Busy polling still needs to be enabled at runtime via sysctl.

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

