Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3GJMRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:17:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:44249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3GJMRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:17:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="363103018"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH] socket.7: add description for SO_BUSY_POLL
To: Micahel Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 10 Jul 2013 15:17:45 +0300
Message-ID: <20130710121745.13118.86907.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.

Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 man7/socket.7 |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/man7/socket.7 b/man7/socket.7
index f2213eb..27603c9 100644
--- a/man7/socket.7
+++ b/man7/socket.7
@@ -694,6 +694,31 @@ for details on control messages.
 Gets the socket type as an integer (e.g.,
 .BR SOCK_STREAM ).
 This socket option is read-only.
+.TP
+.B SO_BUSY_POLL
+Sets the approximate time in microseconds to busy poll on a blocking receive
+when there is no data. Increasing this value requires
+.BR CAP_NET_ADMIN . 
+The default for this option is controlled by the
+.I /proc/sys/net/core/busy_read
+file. 
+
+The value in the  
+.I /proc/sys/net/core/busy_poll
+file determines how long 
+.BR select (2)
+and 
+.BR poll (2)
+will busy poll when they operate on sockets with 
+.BR SO_BUSY_POLL
+set and no events to report are found.
+
+In both cases busy polling will only be done when the socket last received data
+from a network device that supports this option.
+
+While busy polling my improve latency of some application, care must be
+taken when using it since this will increase both CPU utilization power usage.
+
 .SS Signals
 When writing onto a connection-oriented socket that has been shut down
 (by the local or the remote end)

