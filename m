Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080Ab3DBWV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:21:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731Ab3DBWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/68] bonding: remove already created master sysfs link on failure
Date: Tue,  2 Apr 2013 15:13:42 -0700
Message-Id: <20130402221336.106693944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 9fe16b78ee17579cb4f333534cf7043e94c67024 ]

If slave sysfs symlink failes to be created - we end up without removing
the master sysfs symlink. Remove it in case of failure.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -183,6 +183,11 @@ int bond_create_slave_symlinks(struct ne
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


