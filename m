Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938Ab3DGXcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:32:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46823 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934759Ab3DGXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:32:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@redhat.com>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.727557614@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [60/74] bonding: remove already created master sysfs link on  failure
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 9fe16b78ee17579cb4f333534cf7043e94c67024 ]

If slave sysfs symlink failes to be created - we end up without removing
the master sysfs symlink. Remove it in case of failure.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index a549f36..8d923d3 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -184,6 +184,11 @@ int bond_create_slave_symlinks(struct net_device *master,
 	sprintf(linkname, "slave_%s", slave->name);
 	ret = sysfs_create_link(&(master->dev.kobj), &(slave->dev.kobj),
 				linkname);
+
+	/* free the master link created earlier in case of error */
+	if (ret)
+		sysfs_remove_link(&(slave->dev.kobj), "master");
+
 	return ret;
 
 }

