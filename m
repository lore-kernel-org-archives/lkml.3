Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422979Ab3BANO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:45737 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854Ab3BANOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 80/89] netfilter: fix missing dependencies for the NOTRACK target
Date: Fri,  1 Feb 2013 14:08:35 +0100
Message-Id: <20130201130213.241925067@linuxfoundation.org>
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

commit 757ae316fb35811cfd8c67de0e0b8680ec4c1f37 upstream.

warning: (NETFILTER_XT_TARGET_NOTRACK) selects NETFILTER_XT_TARGET_CT which has unmet direct
+dependencies (NET && INET && NETFILTER && NETFILTER_XTABLES && NF_CONNTRACK && (IP_NF_RAW ||
+IP6_NF_RAW) && NETFILTER_ADVANCED)

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -682,6 +682,9 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  '"NOTRACK" target support (DEPRECATED)'
+	depends on NF_CONNTRACK
+	depends on IP_NF_RAW || IP6_NF_RAW
+	depends on NETFILTER_ADVANCED
 	select NETFILTER_XT_TARGET_CT
 
 config NETFILTER_XT_TARGET_RATEEST


