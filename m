Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaDTHWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 03:22:33 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:47786 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbaDTHWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 03:22:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYIAIlLU1NR86LL/2dsb2JhbABYgwaCXqhsmWKBGRd0gmYcIxiBAiQTiEUBzQ0XjmKEPwEDjmmKBAGKaodlgzM7
Date: Sun, 20 Apr 2014 09:22:18 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS: Use device_initcall
Message-Id: <20140420092218.37091f597bd32d9a730d6b4f@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace deprecated __initcall

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/aio.c          | 2 +-
 fs/compat_ioctl.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0e..6279d88 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -222,7 +222,7 @@ static int __init aio_setup(void)
 
 	return 0;
 }
-__initcall(aio_setup);
+device_initcall(aio_setup);
 
 static void put_aio_ring_file(struct kioctx *ctx)
 {
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index e822890..3bfcb0e 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1633,4 +1633,4 @@ static int __init init_sys32_ioctl(void)
 		init_sys32_ioctl_cmp, NULL);
 	return 0;
 }
-__initcall(init_sys32_ioctl);
+device_initcall(init_sys32_ioctl);
-- 
1.8.3.2
