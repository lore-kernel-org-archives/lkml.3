Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377Ab3DCOBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:01:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45394 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622Ab3DCOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:01:07 -0400
X-Sasl-enc: gaKN1FwVyJNyxn2gewpIHet/ipnZxW3zjoPjgpUAOPZS 1364997666
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/4] 802.15.4 and 6LoWPAN Buffering Fixes
Date: Wed,  3 Apr 2013 10:00:54 -0400
Message-Id: <1364997658-16498-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this patch series:

Differences from v1:

1. Patches previously numbered 5 and 6 were squashed (to become current
patch #4) at the request of Alexander Smirnov.

2. Current patch #2 had extraneous braces removed.

3. Current patch #1 was changed. It is now a patch to make mac802154 _not_
retry sending packets on failure. I believe this to be consistent with the
802.15.4 specification (Section 7.5.6.4.3 of IEEE 802.15.4-2006)

Alan Ott (4):
  mac802154: Do not try to resend failed packets
  mac802154: Use netif flow control
  mac802154: Increase tx_buffer_len
  6lowpan: handle dev_queue_xmit() error code properly

 net/ieee802154/6lowpan.c  |  4 ++--
 net/mac802154/mac802154.h |  2 --
 net/mac802154/tx.c        | 26 ++++++++++++++++----------
 net/mac802154/wpan.c      |  2 +-
 4 files changed, 19 insertions(+), 15 deletions(-)

-- 
1.7.11.2

