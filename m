Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3ILR7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3ILR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>
Subject: [ 04/46] macvlan: validate flags
Date: Thu, 12 Sep 2013 10:58:15 -0700
Message-Id: <20130912175721.545555624@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -727,6 +727,10 @@ static int macvlan_validate(struct nlatt
 			return -EADDRNOTAVAIL;
 	}
 
+	if (data && data[IFLA_MACVLAN_FLAGS] &&
+	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~MACVLAN_FLAG_NOPROMISC)
+		return -EINVAL;
+
 	if (data && data[IFLA_MACVLAN_MODE]) {
 		switch (nla_get_u32(data[IFLA_MACVLAN_MODE])) {
 		case MACVLAN_MODE_PRIVATE:


