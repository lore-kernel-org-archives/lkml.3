Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3GJONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:13:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:63379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3GJONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="368051225"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH net-next v3 0/3] net: finish renaming lls to busy poll
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Eric Dumazet <erdnetdev@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 10 Jul 2013 17:13:07 +0300
Message-ID: <20130710141307.15596.47242.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Here are three patches that complete the rename of lls to busy-poll

1. rename include/net/ll_poll.h to include/net/busy_poll.h
2. Rename ndo_ll_poll to ndo_busy_poll.
   Rename sk_mark_ll to sk_mark_napi_id.
   Rename skb_mark_ll to skb_mark_napi_id.
   Correct all useres of these functions.
   Update comments and defines  in include/net/busy_poll.h
3. Rename LL_SO to BUSY_POLL_SO
   Rename sysctl_net_ll_{read,poll} to sysctl_busy_{read,poll}
   Fix up users of these variables.
   Fix documentation for sysctl.

v2 fixed forgetting the ndo changes in v1
v3 is a resend with -M

-Eliezer
