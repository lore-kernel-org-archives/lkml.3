Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092Ab3DBWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:20:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3DBWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Andrey Vagin <avagin@openvz.org>
Subject: [ 58/68] net: fix *_DIAG_MAX constants
Date: Tue,  2 Apr 2013 15:13:47 -0700
Message-Id: <20130402221336.688014846@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/unix_diag.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/unix_diag.h
+++ b/include/linux/unix_diag.h
@@ -38,9 +38,11 @@ enum {
 	UNIX_DIAG_RQLEN,
 	UNIX_DIAG_MEMINFO,
 
-	UNIX_DIAG_MAX,
+	__UNIX_DIAG_MAX,
 };
 
+#define UNIX_DIAG_MAX (__UNIX_DIAG_MAX - 1)
+
 struct unix_diag_vfs {
 	__u32	udiag_vfs_ino;
 	__u32	udiag_vfs_dev;


