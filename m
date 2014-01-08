Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbaAHUjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:39:45 -0500
Received: from mout2.freenet.de ([195.4.92.92]:33830 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397AbaAHUjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:39:41 -0500
Message-ID: <52CDB6CB.8080803@01019freenet.de>
Date: Wed, 08 Jan 2014 21:36:27 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0 SeaMonkey/2.23
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cong Wang <amwang@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Out of the box (ootb) multicast broken since Linux 3.5 until min.
 3.12.
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Originated-At: 79.222.9.3!49772
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch:

commit c5c23260594c5701af66ef754916775ba6a46bbc
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Apr 13 02:37:42 2012 +0000

    bridge: Add multicast_querier toggle and disable queries by default

    Sending general queries was implemented as an optimisation to speed
    up convergence on start-up.  In order to prevent interference with
    multicast routers a zero source address has to be used.

    Unfortunately these packets appear to cause some multicast-aware
    switches to misbehave, e.g., by disrupting multicast packets to us.

    Since the multicast snooping feature still functions without sending
    our own queries, this patch will change the default to not send
    queries.

    For those that need queries in order to speed up convergence on
    start-up, a toggle is provided to restore the previous behaviour.

    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>


incompatibly broke ootb multicast in Linux until 3.12 or even higher
(didn't test) for this use case:

http://thread.gmane.org/gmane.linux.kernel/1622550


It is necessary to manually add this switch

echo "1" > /sys/devices/virtual/net/br0/bridge/multicast_querier

to get multicast working again.


Would be nice to get the old behaviour (= working multicast ootb) back
again. This would have saved a lot of time, probably not only in my case
here (e.g. see https://bugzilla.redhat.com/show_bug.cgi?id=880035).


Regards,
Andreas
