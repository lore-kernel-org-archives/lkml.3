Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaHEMHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:07:24 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64225 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaHEMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:07:22 -0400
Date: Tue, 5 Aug 2014 17:37:18 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] sound/oss/opl3: Remove typedef opl_devinfo
Message-ID: <20140805120718.GA12767@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed as they are
never used.

The following Coccinelle semantic patch detects the case.

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 sound/oss/opl3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 4709e59..607cee4 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -52,7 +52,7 @@ struct voice_info
 	int             panning;	/* 0xffff means not set */
 };
 
-typedef struct opl_devinfo
+struct opl_devinfo
 {
 	int             base;
 	int             left_io, right_io;
@@ -73,7 +73,7 @@ typedef struct opl_devinfo
 	unsigned char   cmask;
 
 	int             is_opl4;
-} opl_devinfo;
+};
 
 static struct opl_devinfo *devc = NULL;
 
-- 
1.9.1

