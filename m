Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517Ab3DKUs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:48:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935444Ab3DKUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:51 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KNcFjWkcljcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tMEhWZT_ujcA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202611.665659641@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 155/171 ] bonding: remove already created master sysfs link on failure
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0155-bonding-remove-already-created-master-sysfs-link-on-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 9fe16b78ee17579cb4f333534cf7043e94c67024 ]

If slave sysfs symlink failes to be created - we end up without removing
the master sysfs symlink. Remove it in case of failure.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 21609f9..ecd47a3 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -183,6 +183,11 @@ int bond_create_slave_symlinks(struct net_device *master,
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
-- 
1.7.10.4


