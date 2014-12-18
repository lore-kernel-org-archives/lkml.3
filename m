Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaLROsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:48:25 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61346 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaLROsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:48:24 -0500
Date: Thu, 18 Dec 2014 17:48:10 +0300
From: samuel kihahu <skihahu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        speakup@linux-speakup.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Message-ID: <20141218144810.GA16115@localhost.localdomain>
References: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
 <20141217121119.GL4856@mwanda>
 <20141217134354.GA585@localhost.localdomain>
 <20141217140322.GM4856@mwanda>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20141217140322.GM4856@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2014 at 05:03:22PM +0300, Dan Carpenter wrote:
> On Wed, Dec 17, 2014 at 04:43:54PM +0300, samuel kihahu wrote:
> > On Wed, Dec 17, 2014 at 03:11:19PM +0300, Dan Carpenter wrote:
> > > On Wed, Dec 17, 2014 at 02:56:02PM +0300, samuel kihahu wrote:
> > > > Replacing obsolete simple_strtoul with kstrtoul.
> > > > 
> > > 
> > > Nope.  That's wrong.  Learn how the functions are different beyond just
> > > the name.
> > Noted, have made corrections to fit the kstrtoul and handle the return
> > value.
> 
> You have to compile test these things.  Really kernel programming is not
> a good way to learn how to program.  :(
> 
> regards,
> dan carpenter
> 

Appreciate the feedback, have modified the patch, tested and confirmed
it builds.

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-staging-speakup-replace-simple_strtoul-with-kstrtoul.patch"

>From 3d39fd533b4a75e567f76f07f5bc978adddb0721 Mon Sep 17 00:00:00 2001
From: samuel kihahu <skihahu@gmail.com>
Date: Thu, 18 Dec 2014 17:42:37 +0300
Subject: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul

Replacing obsolete simple_strtoul with kstrtoul, checking and
returning the correct error code.

Signed-off-by: samuel kihahu <skihahu@gmail.com>
---
 drivers/staging/speakup/varhandlers.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index d758284..716ccc1 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -321,9 +321,13 @@ char *spk_strlwr(char *s)
 
 char *spk_s2uchar(char *start, char *dest)
 {
-	int val = 0;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(skip_spaces(start), 10, &val);
+	if (IS_ERR(&ret))
+		return ERR_CAST(&ret);
 
-	val = simple_strtoul(skip_spaces(start), &start, 10);
 	if (*start == ',')
 		start++;
 	*dest = (u_char)val;
-- 
1.8.3.1


--TB36FDmn/VVEgNH/--
