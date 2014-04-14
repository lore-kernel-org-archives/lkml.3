Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaDNRjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:39:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48196 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaDNRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:39:36 -0400
From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4: Add option to get TCP_FASTOPEN to getsockopt()
User-agent: mu4e 0.9.9.5; emacs 24.3.1
Date: Tue, 15 Apr 2014 02:39:31 +0900
Message-ID: <87tx9v3j58.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCP_FASTOPEN option can be set via setsockopt(), but the value cannot be
gotten via getsockopt(). This patch adds the option to getsockopt().

Sighned-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

 	Add option to get TCP_FASTOPEN to getsockopt()
---
 net/ipv4/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4bd6d52..6ccdbcc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2916,6 +2916,11 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_USER_TIMEOUT:
 		val = jiffies_to_msecs(icsk->icsk_user_timeout);
 		break;
+
+	case TCP_FASTOPEN:
+		val = sysctl_tcp_fastopen;
+		break;
+
 	case TCP_TIMESTAMP:
 		val = tcp_time_stamp + tp->tsoffset;
 		break;
--
1.9.0
