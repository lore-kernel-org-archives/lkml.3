Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab3E2Gj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 02:39:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:18872 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab3E2Gj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 02:39:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="344926089"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v6 net-next 0/5] net: low latency Ethernet device polling
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 09:39:16 +0300
Message-ID: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more round of fixes.
Thank you all for your input.

-Eliezer

change log:
v6
- many small fixes suggested by Eric Dumazet:
  data locality, typos, documentation
  protect napi_hash insert/delete with a spinlock (napi_gen_id is no
  longer atomic_t since it's only accessed with the spinlock held.)
- added IPv6 TCP and UDP support (only minimally tested)

v5
- corrections suggested by Ben Hutchings:
  fixed typos, moved the config option and sysctl value from IPv4 to net
- moved sk_mark_ll() to the protocol handlers
- removed global id mechanism, replaced with a hashed napi_id.
  based on code sample from Eric Dumazet
  Note that ixgbe_free_q_vector() already waits an rcu grace period
  before freeing the q_vector, so nothing additional needs to be done
  when adding a call to napi_hash_del().
- simple poll/select support

v4
- removed separate config option for TCP as suggested Eric Dumazet.
- added linux mib counter for packets received through the low latency path,
  as suggested by Andi Kleen.
- re-allow module unloading, remove module param, use a global generation id
  instead to prevent the use of a stale napi pointer, as suggested
  by Eric Dumazet
- updated Documentation/networking/ip-sysctl.txt text

v3
- coding style changes suggested by Dave Miller

v2
- the sysctl knob is now in microseconds. The default value is now 0 (off).
- for now the code depends at configure time on CONFIG_I86_TSC 
- the napi reference in struct skb is now a union with the dma cookie
  since the former is only used on RX and the latter on TX,
  as suggested by Eric Dumazet.
- we do a better job at honoring non-blocking operations.
- removed busy-polling support for tcp_read_sock()
- remove dynamic disabling of GRO
- coding style fixes
- disallow unloading the device module after the feature has been used

Credit:
Jesse Brandeburg, Arun Chekhov Ilango, Julie Cummings,
Alexander Duyck, Eric Geisler, Jason Neighbors, Yadong Li,
Mike Polehn, Anil Vasudevan, Don Wood
Special thanks for finding bugs in earlier versions:
Willem de Bruijn and Andi Kleen

Thanks,
Eliezer
