Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaJCXpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:45:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbaJCWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aleksey Senin <alekseys@mellanox.com>,
        Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.16 300/357] IB/core: When marshaling uverbs path, clear unused fields
Date: Fri,  3 Oct 2014 14:31:26 -0700
Message-Id: <20141003212942.492581294@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matan Barak <matanb@mellanox.com>

commit a59c5850f09b4c2d6ad2fc47e5e1be8d654529d6 upstream.

When marsheling a user path to the kernel struct ib_sa_path, need
to zero smac, dmac and set the vlan id to the "no vlan" value.

Fixes: dd5f03beb4f7 ("IB/core: Ethernet L2 attributes in verbs/cm structures")
Reported-by: Aleksey Senin <alekseys@mellanox.com>
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_marshall.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -140,5 +140,9 @@ void ib_copy_path_rec_from_user(struct i
 	dst->packet_life_time	= src->packet_life_time;
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
+
+	memset(dst->smac, 0, sizeof(dst->smac));
+	memset(dst->dmac, 0, sizeof(dst->dmac));
+	dst->vlan_id = 0xffff;
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);


