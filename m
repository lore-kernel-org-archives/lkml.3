Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3I0Phj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:37:39 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:41636 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3I0Phc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:37:32 -0400
From: Martin Berglund <martin@rogsta.net>
To: dan.carpenter@oracle.com
Cc: teddy.wang@siliconmotion.com.cn, gregkh@linuxfoundation.org,
        wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin@rogsta.net
Subject: Re: [PATCH] Staging: sm7xxfb: fixed line break coding style issues
Date: Fri, 27 Sep 2013 17:39:11 +0200
Message-Id: <1380296351-18906-1-git-send-email-martin@rogsta.net>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20130927122728.GE6192@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 03:27:29PM +0300, Dan Carpenter wrote:
> On Fri, Sep 27, 2013 at 02:08:07PM +0200, Martin Berglund wrote:
> > @@ -508,9 +506,8 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
> >  
> >  			/* init SEQ register SR30 - SR75 */
> >  			for (i = 0; i < SIZE_SR30_SR75; i++)
> > -				if (((i + 0x30) != 0x62) \
> > -					&& ((i + 0x30) != 0x6a) \
> > -					&& ((i + 0x30) != 0x6b))
> > +				if (((i + 0x30) != 0x62) && ((i + 0x30) != 0x6a)
> > +							&& ((i + 0x30) != 0x6b))
> 
> The prefered way would be to align this like this:
> 
> 				if ((i + 0x30) != 0x62 &&
> 				    (i + 0x30) != 0x6a &&
> 				    (i + 0x30) != 0x6b)
> 
> regards,
> dan carpenter
> 

New patch.

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
 drivers/staging/sm7xxfb/sm7xxfb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 8add64b..8ba0097 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -259,8 +259,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			if (sfb->fb.var.bits_per_pixel == 16) {
 				u32 *pal = sfb->fb.pseudo_palette;
 				val = chan_to_field(red, &sfb->fb.var.red);
-				val |= chan_to_field(green, \
-						&sfb->fb.var.green);
+				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
 #ifdef __BIG_ENDIAN
 				pal[regno] =
@@ -274,8 +273,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			} else {
 				u32 *pal = sfb->fb.pseudo_palette;
 				val = chan_to_field(red, &sfb->fb.var.red);
-				val |= chan_to_field(green, \
-						&sfb->fb.var.green);
+				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
 #ifdef __BIG_ENDIAN
 				val =
@@ -508,9 +506,9 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
 
 			/* init SEQ register SR30 - SR75 */
 			for (i = 0; i < SIZE_SR30_SR75; i++)
-				if (((i + 0x30) != 0x62) \
-					&& ((i + 0x30) != 0x6a) \
-					&& ((i + 0x30) != 0x6b))
+				if ((i + 0x30) != 0x62 &&
+				    (i + 0x30) != 0x6a &&
+				    (i + 0x30) != 0x6b)
 					smtc_seqw(i + 0x30,
 						VGAMode[j].Init_SR30_SR75[i]);
 
-- 
1.8.4

