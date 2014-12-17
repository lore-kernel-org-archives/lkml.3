Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaLQNoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:44:09 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60694 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaLQNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:44:08 -0500
Date: Wed, 17 Dec 2014 16:43:54 +0300
From: samuel kihahu <skihahu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        speakup@linux-speakup.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Message-ID: <20141217134354.GA585@localhost.localdomain>
References: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
 <20141217121119.GL4856@mwanda>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20141217121119.GL4856@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2014 at 03:11:19PM +0300, Dan Carpenter wrote:
> On Wed, Dec 17, 2014 at 02:56:02PM +0300, samuel kihahu wrote:
> > Replacing obsolete simple_strtoul with kstrtoul.
> > 
> 
> Nope.  That's wrong.  Learn how the functions are different beyond just
> the name.
Noted, have made corrections to fit the kstrtoul and handle the return
value.

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-staging-speakup-replace-simple_strtoul-with-kstrtoul.patch"

>From 71d2f7123e697b95371585b4af9a0b35262307ea Mon Sep 17 00:00:00 2001
From: samuel kihahu <skihahu@gmail.com>
Date: Wed, 17 Dec 2014 16:31:05 +0300
Subject: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul

Replacing obsolete simple_strtoul with kstrtoul and checking the
return status.

Signed-off-by: samuel kihahu <skihahu@gmail.com>
---
 drivers/staging/speakup/varhandlers.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index d758284..8ac9ad7 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -321,9 +321,10 @@ char *spk_strlwr(char *s)
 
 char *spk_s2uchar(char *start, char *dest)
 {
-	int val = 0;
+	unsigned long val;
 
-	val = simple_strtoul(skip_spaces(start), &start, 10);
+	if (kstrtoul(skip_spaces(start), &start, val))
+		return -EINVAL;
 	if (*start == ',')
 		start++;
 	*dest = (u_char)val;
-- 
1.8.3.1


--17pEHd4RhPHOinZp--
