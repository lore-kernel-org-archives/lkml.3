Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3D2TCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:02:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3D2TCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/42] bonding: IFF_BONDING is not stripped on enslave failure
Date: Mon, 29 Apr 2013 12:02:06 -0700
Message-Id: <20130429184755.137050534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1888,6 +1888,7 @@ err_detach:
 	write_unlock_bh(&bond->lock);
 
 err_close:
+	slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_unset_master:


