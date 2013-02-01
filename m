Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954Ab3BANOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:45650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936Ab3BANOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 78/89] netfilter: nfnetlink_log: fix possible compilation issue due to missing include
Date: Fri,  1 Feb 2013 14:08:33 +0100
Message-Id: <20130201130213.101483984@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit e035edd16ee83498cccc9beedfc215e15cab3a07 upstream.

In (0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels)
the include file that defines ARPD_SIT was missing. This passed unnoticed
during my tests (I did not hit this problem here).

net/netfilter/nfnetlink_log.c: In function '__build_packet_message':
net/netfilter/nfnetlink_log.c:494:25: error: 'ARPHRD_SIT' undeclared (first use in this function)
net/netfilter/nfnetlink_log.c:494:25: note: each undeclared identifier is reported only once for
+each function it appears in

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

---
 net/netfilter/nfnetlink_log.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -13,6 +13,7 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>


