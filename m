Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3LBU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:28:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3LBTQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 3.12 011/212] staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic
Date: Mon,  2 Dec 2013 11:13:22 -0800
Message-Id: <20131202191249.899688827@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit b39f15c972c462903208531b82f9b34ba8ef3ec0 upstream.

It was introduced due to a patch hunk when porting
commit 20802057 (staging/lustre/ptlrpc: race in pinger).

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -409,8 +409,8 @@ int ptlrpc_stop_pinger(void)
 	struct l_wait_info lwi = { 0 };
 	int rc = 0;
 
-	if (!thread_is_init(&pinger_thread) &&
-	    !thread_is_stopped(&pinger_thread))
+	if (thread_is_init(&pinger_thread) ||
+	    thread_is_stopped(&pinger_thread))
 		return -EALREADY;
 
 	ptlrpc_pinger_remove_timeouts();


