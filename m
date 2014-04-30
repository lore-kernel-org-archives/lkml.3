Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946016AbaD3UJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:09:15 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:35514 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbaD3UJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:09:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsGALhXYVNXQ3IO/2dsb2JhbABZgwaCQMMygSAXdIJmHCMYgQIkE4hFAcoGjlGEQAEDjxOKEwGKeodxgzM7
Date: Wed, 30 Apr 2014 22:09:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/libcrc32c.c: use PTR_ERR_OR_ZERO
Message-Id: <20140430220909.e0f6110ffed5d898e2978d76@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/libcrc32c.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..b3131f5 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -62,10 +62,7 @@ EXPORT_SYMBOL(crc32c);
 static int __init libcrc32c_mod_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(tfm);
 }
 
 static void __exit libcrc32c_mod_fini(void)
-- 
1.9.1

