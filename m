Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab3BKTpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:45:25 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42483 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759711Ab3BKTpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:45:10 -0500
Message-Id: <20130211194509.035828372@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Mon, 11 Feb 2013 13:45:14 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 6/7] x86/UV/UV3: Check current gru hub support for SGI UV3
References: <20130211194508.033167376@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv3-update-gru-syscheck
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks current hub support to avoid panicing the
system until all the GRU changes for UV3+ are in place.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/misc/sgi-gru/grufile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/drivers/misc/sgi-gru/grufile.c
+++ linux/drivers/misc/sgi-gru/grufile.c
@@ -517,7 +517,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system())
+	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
 		return 0;
 
 #if defined CONFIG_IA64

