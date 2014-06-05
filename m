Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaFEFP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:15:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaFEEUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Richter <tmricht@linux.vnet.ibm.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 019/214] bonding: Remove debug_fs files when module init fails
Date: Wed,  4 Jun 2014 21:16:22 -0700
Message-Id: <20140605041642.344641271@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.vnet.ibm.com>

[ Upstream commit db29868653394937037d71dc3545768302dda643 ]

Remove the bonding debug_fs entries when the
module initialization fails. The debug_fs
entries should be removed together with all other
already allocated resources.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
Signed-off-by: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4930,6 +4930,7 @@ static int __init bonding_init(void)
 out:
 	return res;
 err:
+	bond_destroy_debugfs();
 	rtnl_link_unregister(&bond_link_ops);
 err_link:
 	unregister_pernet_subsys(&bond_net_ops);


