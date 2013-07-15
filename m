Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3GOIoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:44:09 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64605 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab3GOIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:44:08 -0400
Message-ID: <1373877845.2591.9.camel@x61.thuisdomein>
Subject: 9P: hook up rdma_cancelled() into p9_rdma_trans?
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 10:44:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2013 08:44:06.0035 (UTC) FILETIME=[77056630:01CE8137]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Building trans_rdma.o (in v3.11-rc1) triggers a warning:
    net/9p/trans_rdma.c:594:12: warning: ‘rdma_cancelled’ defined but not used [-Wunused-function]

1) Did commit 80b45261a0 ("9P: Add cancelled() to the transport
functions.") forget to actually hook up rdma_cancelled() into
p9_rdma_trans()? Say, like this:

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 928f2bb..0c42b1c 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -732,6 +732,7 @@ static struct p9_trans_module p9_rdma_trans = {
 	.close = rdma_close,
 	.request = rdma_request,
 	.cancel = rdma_cancel,
+	.cancelled = rdma_cancelled,
 };
 
 /**

That (compile tested only) patch silences this warning. Is there a patch
queued to do something like this? I couldn't find it.


Paul Bolle

