Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaBHJTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 04:19:48 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:60538 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaBHJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 04:19:45 -0500
Date: Sat, 8 Feb 2014 10:19:44 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tcp: disable auto corking by default
Message-ID: <20140208091944.GB16336@glanzmann.de>
Mail-Followup-To: Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140206153640.GB4103@glanzmann.de>
 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
 <20140207051500.GB10916@glanzmann.de>
 <20140207075536.GB17815@glanzmann.de>
 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
 <20140207205142.GA8609@glanzmann.de>
 <20140208091828.GA16336@glanzmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208091828.GA16336@glanzmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using auto corking with iSCSI the round trip time at least increases by
factor 25 probably more. Other protocols are very likely also effected.

Signed-off-by: Thomas Glanzmann <thomas@glanzmann.de>
---
 net/ipv4/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4475b3b..da563a4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -285,7 +285,7 @@ int sysctl_tcp_fin_timeout __read_mostly = TCP_FIN_TIMEOUT;
 
 int sysctl_tcp_min_tso_segs __read_mostly = 2;
 
-int sysctl_tcp_autocorking __read_mostly = 1;
+int sysctl_tcp_autocorking __read_mostly = 0;
 
 struct percpu_counter tcp_orphan_count;
 EXPORT_SYMBOL_GPL(tcp_orphan_count);
-- 
1.7.10.4
