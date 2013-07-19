Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965883Ab3GSF1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:27:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859Ab3GSF1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 72/72] UBIFS: correct mount message
Date: Thu, 18 Jul 2013 22:26:29 -0700
Message-Id: <20130719052604.781222495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@gmail.com>

commit beadadfa5467e09e36891f39cae1f5d8d3bbf17e upstream.

When mounting an UBIFS R/W volume, we have the message:
UBIFS: mounted UBI device 0, volume 1, name "rootfs"(null)
With this patch, we'll have:
UBIFS: mounted UBI device 0, volume 1, name "rootfs"
Which is, I think, what was intended.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1412,7 +1412,7 @@ static int mount_ubifs(struct ubifs_info
 
 	ubifs_msg("mounted UBI device %d, volume %d, name \"%s\"%s",
 		  c->vi.ubi_num, c->vi.vol_id, c->vi.name,
-		  c->ro_mount ? ", R/O mode" : NULL);
+		  c->ro_mount ? ", R/O mode" : "");
 	x = (long long)c->main_lebs * c->leb_size;
 	y = (long long)c->log_lebs * c->leb_size + c->max_bud_bytes;
 	ubifs_msg("LEB size: %d bytes (%d KiB), min./max. I/O unit sizes: %d bytes/%d bytes",


