Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3JJPom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3JJPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 004/104] macvlan: validate flags
Date: Thu, 10 Oct 2013 08:40:52 -0700
Message-Id: <1381419752-29733-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 1512747820367c8b3b8b72035f0f78c62f2bf1e9 ]

commit df8ef8f3aaa6692970a436204c4429210addb23a
    macvlan: add FDB bridge ops and macvlan flags
added a flags field to macvlan, which can be
controlled from userspace.
The idea is to make the interface future-proof
so we can add flags and not new fields.

However, flags value isn't validated, as a result,
userspace can't detect which flags are supported.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d30fc4d..931a4d7 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -688,6 +688,10 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[])
 			return -EADDRNOTAVAIL;
 	}
 
+	if (data && data[IFLA_MACVLAN_FLAGS] &&
+	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~MACVLAN_FLAG_NOPROMISC)
+		return -EINVAL;
+
 	if (data && data[IFLA_MACVLAN_MODE]) {
 		switch (nla_get_u32(data[IFLA_MACVLAN_MODE])) {
 		case MACVLAN_MODE_PRIVATE:
-- 
1.8.1.2

