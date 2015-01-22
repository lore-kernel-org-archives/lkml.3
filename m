Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbbAVAoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:44:17 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55891 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753082AbbAVAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:43:06 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dev@openvswitch.org, pshelar@nicira.com
Subject: [PATCH net-next v14 4/5] genetlink: Add genlmsg_parse() helper function.
Date: Wed, 21 Jan 2015 16:42:51 -0800
Message-Id: <1421887372-56414-5-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
References: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first user will be the next patch.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 include/net/genetlink.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index f24aa83..d5a9a8b 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -206,6 +206,23 @@ static inline struct nlmsghdr *genlmsg_nlhdr(void *user_hdr,
 }
 
 /**
+ * genlmsg_parse - parse attributes of a genetlink message
+ * @nlh: netlink message header
+ * @family: genetlink message family
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
+ * */
+static inline int genlmsg_parse(const struct nlmsghdr *nlh,
+				const struct genl_family *family,
+				struct nlattr *tb[], int maxtype,
+				const struct nla_policy *policy)
+{
+	return nlmsg_parse(nlh, family->hdrsize + GENL_HDRLEN, tb, maxtype,
+			   policy);
+}
+
+/**
  * genl_dump_check_consistent - check if sequence is consistent and advertise if not
  * @cb: netlink callback structure that stores the sequence number
  * @user_hdr: user header as returned from genlmsg_put()
-- 
1.7.10.4

