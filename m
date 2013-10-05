Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3JER5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:57:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61283 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3JER5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:57:36 -0400
Date: Sun, 6 Oct 2013 01:57:15 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, yann.morin.1998@free.fr, bpoirier@suse.de,
        walch.martin@web.de, jdelvare@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH]kconfig:mconf: avoid unneeded memcpy
Message-ID: <20131005175715.GA28091@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, yann.morin.1998@free.fr,
	bpoirier@suse.de, walch.martin@web.de, jdelvare@suse.de,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function update_text we assign jump key label
per page (1)-(9) cycled, and use three space char
as the header after k exceed JUMP_NB.

We don't need to call memcpy with header of three
space char, because it changes nothing, it just
copy what was there.

I don't think we need to clear old jump key label in
current implementation, I can't image out any case
which a search result could change its jump key label,
unless user search new string, but then we will re-assign
jump key label, and it will be fix after that.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/mconf.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2c39631..ff9d737 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -379,11 +379,8 @@ static void update_text(char *buf, size_t start, size_t end, void *_data)
 				data->keys[k] = key;
 				data->targets[k] = pos->target;
 				k++;
-			} else {
-				sprintf(header, "   ");
+				memcpy(buf + pos->offset, header, sizeof(header) - 1);
 			}
-
-			memcpy(buf + pos->offset, header, sizeof(header) - 1);
 		}
 	}
 	data->keys[k] = 0;
-- 
1.7.12.4.dirty
