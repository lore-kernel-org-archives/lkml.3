Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3EJOUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab3EJOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "nikolay@redhat.com" <nikolay@redhat.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.716258675@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [090/118] bonding: IFF_BONDING is not stripped on enslave  failure
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit b6a5a7b9a528a8b4c8bec940b607c5dd9102b8cc ]

While enslaving a new device and after IFF_BONDING flag is set, in case
of failure it is not stripped from the device's priv_flags while
cleaning up, which could lead to other problems.
Cleaning at err_close because the flag is set after dev_open().

v2: no change

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1866,6 +1866,7 @@ err_detach:
 	write_unlock_bh(&bond->lock);
 
 err_close:
+	slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_unset_master:

