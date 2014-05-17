Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaEQIdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 04:33:11 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:51580 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757187AbaEQIdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 04:33:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEWAN8dd1NXQxKA/2dsb2JhbABZgwaCQn2nMAcBAQEFAZonAgKBChd0gmYcIxiBAiQTiEUB0TKFVYgWZIRHAQOPLooqAYsRiAmBd4FCO4Ex
Date: Sat, 17 May 2014 10:33:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: [PATCH 1/1 linux-next] fs/cifs/inode.c: replace deprecated
 smp_mb__after_clear_bit
Message-Id: <20140517103306.4ddd9b979c728d6969b6f9c4@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

based on
febdbfe8a91ce0
"arch: Prepare for smp_mb__{before,after}_atomic()"

Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9ff8df8..a174605 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1806,7 +1806,7 @@ cifs_revalidate_mapping(struct inode *inode)
 	}
 
 	clear_bit_unlock(CIFS_INO_LOCK, flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(flags, CIFS_INO_LOCK);
 
 	return rc;
-- 
1.8.4.5

