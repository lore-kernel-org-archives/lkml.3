Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3FEWKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:10:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3FEVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Deepak Arora <deepakx.arora@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 013/127] cfg80211: fix sending WoWLAN TCP wakeup settings
Date: Wed,  5 Jun 2013 14:33:00 -0700
Message-Id: <20130605213219.540177148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit e248ad30204eff6559b4d2d94d49d9d46c08185a upstream.

The code sending the current WoWLAN TCP wakeup settings in
nl80211_send_wowlan_tcp() is not closing the nested attribute,
thus causing the parser to get confused on the receiver side
in userspace (iw). Fix this.

Reported-by: Deepak Arora <deepakx.arora@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7177,6 +7177,8 @@ static int nl80211_send_wowlan_tcp(struc
 		    &tcp->payload_tok))
 		return -ENOBUFS;
 
+	nla_nest_end(msg, nl_tcp);
+
 	return 0;
 }
 


