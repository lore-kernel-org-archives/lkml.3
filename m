Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580Ab3IDAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:14:17 -0400
Received: from mout.web.de ([212.227.15.3]:57796 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3IDAOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:14:16 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: bride: IPv6 multicast snooping enhancements
Date: Wed,  4 Sep 2013 02:13:37 +0200
Message-Id: <1378253619-23918-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:RO4G8x1WdKxRGSkwYrH0KLQ8Rmk87s1XoFXyRTy6677u5o9r1JR
 0zz6XYcr7/tnseu+8zf77M2EKNnws0lxMAqQRLc7zS1RkPtORmq+aS/EDLXpaZtY7fl9T2A
 K+WrPo4pHzCXeu7dN9K28KBKd/JHy/U4gmDq379varTegOUOCPG8Lf7mY9uKFepJuNMnNSn
 YBMDNbLpAwzIkD14DbvDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two, small feature changes I would like to submit to increase
the usefulness of the multicast snooping of the bridge code.

The first patch is an unaltered one I had submitted before, but since it
got no feedback I'm resubmitting it here for net-next. With the recently
added patch to disable snooping if there is no querier (b00589af + 248ba8ec05
+ 8d50af4fb), it should be a safe choice now (without these, patch 1/2 would
have introduced another potential for lost IPv6 multicast packets).

Both conceptually and also with some testing and fuzzing, I couldn't spot
any more causes for potential packet loss. And since the multicast snooping
code has now been tried by various people, I think it should be a safe
choice to apply the multicast snooping not only for IPv6 multicast packets
with a scope greater than link-local, but also for packets of exactly this
scope. The IPv6 standard mandates MLD reports for link-local multicast, too,
so we can safely snoop them as well (in contrast to IPv4 link-local).

Cheers, Linus


