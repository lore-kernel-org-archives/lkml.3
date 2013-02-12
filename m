Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3BLEW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:22:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3BLEW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:22:56 -0500
Date: Mon, 11 Feb 2013 20:22:45 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-385404e0ce4dbceb72f3f89cb172b2e60ef8e6d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, tglx@linutronix.de, hpa@linux.intel.com,
        sivanich@sgi.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, tglx@linutronix.de, sivanich@sgi.com,
        hpa@linux.intel.com
In-Reply-To: <20130211194509.035828372@gulag1.americas.sgi.com>
References: <20130211194509.035828372@gulag1.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv, uv3:
  Check current gru hub support for SGI UV3
Git-Commit-ID: 385404e0ce4dbceb72f3f89cb172b2e60ef8e6d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 20:22:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  385404e0ce4dbceb72f3f89cb172b2e60ef8e6d3
Gitweb:     http://git.kernel.org/tip/385404e0ce4dbceb72f3f89cb172b2e60ef8e6d3
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 11 Feb 2013 13:45:14 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Feb 2013 17:18:19 -0800

x86, uv, uv3: Check current gru hub support for SGI UV3

This patch checks current hub support to avoid panicing the
system until all the GRU changes for UV3+ are in place.

Signed-off-by: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/20130211194509.035828372@gulag1.americas.sgi.com
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/misc/sgi-gru/grufile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 492c8ca..44d273c 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -517,7 +517,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system())
+	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
 		return 0;
 
 #if defined CONFIG_IA64
