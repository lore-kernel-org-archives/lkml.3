Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3EHSNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:13:40 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39177 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3EHSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:13:39 -0400
Date: Thu, 9 May 2013 02:13:30 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] fbcon: convert last fbcon_takeover call to
 do_fbcon_takeover
Message-ID: <20130508181330.GB12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 054430e773c9a1e26f38e30156eff02dedfffc17 (fbcon: fix locking harder),
there is only one place use do_fbcon_takeover now, this patch
convert it to do_fbcon_takeover too, then we can delete
fbcon_takeover whos function can be achieved with do_fbcon_takeover
easily to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/console/fbcon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3cd6759..1660644 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3541,8 +3541,9 @@ static void fbcon_start(void)
 			}
 		}
 
+		do_fbcon_takeover(0);
 		console_unlock();
-		fbcon_takeover(0);
+
 	}
 }
 
-- 
1.7.12.4.dirty
