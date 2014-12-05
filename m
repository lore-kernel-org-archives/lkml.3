Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaLEXAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:00:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaLEW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cwang@twopensource.com>
Subject: [PATCH 3.14 71/73] batman: fix a bogus warning from batadv_is_on_batman_iface()
Date: Fri,  5 Dec 2014 14:45:17 -0800
Message-Id: <20141205224436.061307958@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

commit b6ed5498601df40489606dbc14a9c7011c16630b upstream.

batman tries to search dev->iflink to check if it's a batman interface,
but ->iflink could be 0, which is not a valid ifindex. It should just
avoid iflink == 0 case.

Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Antonio Quartulli <antonio@open-mesh.com>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/hard-interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -83,7 +83,7 @@ static bool batadv_is_on_batman_iface(co
 		return true;
 
 	/* no more parents..stop recursion */
-	if (net_dev->iflink == net_dev->ifindex)
+	if (net_dev->iflink == 0 || net_dev->iflink == net_dev->ifindex)
 		return false;
 
 	/* recurse over the parent device */


