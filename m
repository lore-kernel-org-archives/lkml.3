Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3ILSY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:24:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3ILR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/46] rtnetlink: Fix inverted check in ndo_dflt_fdb_del()
Date: Thu, 12 Sep 2013 10:58:25 -0700
Message-Id: <20130912175722.593718496@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

[ Upstream commit 645359930231d5e78fd3296a38b98c1a658a7ade ]

Fix inverted check when deleting an fdb entry.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2142,7 +2142,7 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
 	/* If aging addresses are supported device will need to
 	 * implement its own handler for this.
 	 */
-	if (ndm->ndm_state & NUD_PERMANENT) {
+	if (!(ndm->ndm_state & NUD_PERMANENT)) {
 		pr_info("%s: FDB only supports static addresses\n", dev->name);
 		return -EINVAL;
 	}


