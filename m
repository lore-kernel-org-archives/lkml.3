Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab3DBWiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:38:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3DBWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Andrey Vagin <avagin@openvz.org>
Subject: [ 110/124] net: fix *_DIAG_MAX constants
Date: Tue,  2 Apr 2013 15:11:32 -0700
Message-Id: <20130402221116.952615014@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Andrey Vagin <avagin@openvz.org>

[ Upstream commit ae5fc98728c8bbbd6d7cab0b9781671fc4419c1b ]

Follow the common pattern and define *_DIAG_MAX like:

        [...]
        __XXX_DIAG_MAX,
};

Because everyone is used to do:

        struct nlattr *attrs[XXX_DIAG_MAX+1];

        nla_parse([...], XXX_DIAG_MAX, [...]

Reported-by: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/packet_diag.h |    4 +++-
 include/uapi/linux/unix_diag.h   |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/packet_diag.h
+++ b/include/uapi/linux/packet_diag.h
@@ -33,9 +33,11 @@ enum {
 	PACKET_DIAG_TX_RING,
 	PACKET_DIAG_FANOUT,
 
-	PACKET_DIAG_MAX,
+	__PACKET_DIAG_MAX,
 };
 
+#define PACKET_DIAG_MAX (__PACKET_DIAG_MAX - 1)
+
 struct packet_diag_info {
 	__u32	pdi_index;
 	__u32	pdi_version;
--- a/include/uapi/linux/unix_diag.h
+++ b/include/uapi/linux/unix_diag.h
@@ -39,9 +39,11 @@ enum {
 	UNIX_DIAG_MEMINFO,
 	UNIX_DIAG_SHUTDOWN,
 
-	UNIX_DIAG_MAX,
+	__UNIX_DIAG_MAX,
 };
 
+#define UNIX_DIAG_MAX (__UNIX_DIAG_MAX - 1)
+
 struct unix_diag_vfs {
 	__u32	udiag_vfs_ino;
 	__u32	udiag_vfs_dev;


