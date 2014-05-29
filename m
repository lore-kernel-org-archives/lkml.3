Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbaE2HZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:25:35 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:40801 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932664AbaE2HZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:25:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4JAObfhlNXQ3h6/2dsb2JhbABZgweCRahyCgUBmB6BERd0gmYcIxiBAiQTiEYB10UXhVWIfYRHAQOPQIo0AYsYiBCDOjs
Date: Thu, 29 May 2014 09:25:32 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2 3/3] lib/debugobjects.c: convert printk(KERN_DEBUG to
 pr_debug
Message-Id: <20140529092532.850a410f6df7b3ae57726a41@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct conversion of one KERN_DEBUG message without DEBUG definition
(suggested by Josh Triplett)

That message will now be disabled by default.
(see Documentation/CodingStyle Chapter 13)

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/debugobjects.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index b628247..547f7f9 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -1061,8 +1061,8 @@ static int __init debug_objects_replace_static_objects(void)
 	}
 	local_irq_enable();
 
-	printk(KERN_DEBUG "ODEBUG: %d of %d active objects replaced\n", cnt,
-	       obj_pool_used);
+	pr_debug("%d of %d active objects replaced\n",
+		 cnt, obj_pool_used);
 	return 0;
 free:
 	hlist_for_each_entry_safe(obj, tmp, &objects, node) {
-- 
1.9.1
