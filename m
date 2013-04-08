Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab3DHKDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:03:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935837Ab3DHJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 071/102] net: fix *_DIAG_MAX constants
Date: Mon,  8 Apr 2013 10:50:26 +0100
Message-Id: <1365414657-29191-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit ae5fc98728c8bbbd6d7cab0b9781671fc4419c1b upstream.

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
[ luis: backport to 3.5:
  - fix unix_diag.h path
  - packet_diag.h does not exist ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/unix_diag.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/unix_diag.h b/include/linux/unix_diag.h
index b1d2bf1..0ff4d32 100644
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
-- 
1.8.1.2

