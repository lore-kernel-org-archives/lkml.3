Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3CDESJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:18:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab3CDDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:40 -0500
Message-Id: <20130304033721.510750565@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 142/153] speakup: lower default software speech rate
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit cfd757010691eae4e17acc246f74e7622c3a2f05 upstream.

Speech synthesis beginners need a low speech rate, and trained people
want a high speech rate.  A medium speech rate is thus actually not a
good default for neither.  Since trained people will typically know how
to change the rate, better default for a low speech rate, which
beginners can grasp and learn how to increase it afterwards

This was agreed with users on the speakup mailing list.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/speakup/speakup_soft.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index 42cdafe..2a67610 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -46,7 +46,7 @@ static int misc_registered;
 static struct var_t vars[] = {
 	{ CAPS_START, .u.s = {"\x01+3p" } },
 	{ CAPS_STOP, .u.s = {"\x01-3p" } },
-	{ RATE, .u.n = {"\x01%ds", 5, 0, 9, 0, 0, NULL } },
+	{ RATE, .u.n = {"\x01%ds", 2, 0, 9, 0, 0, NULL } },
 	{ PITCH, .u.n = {"\x01%dp", 5, 0, 9, 0, 0, NULL } },
 	{ VOL, .u.n = {"\x01%dv", 5, 0, 9, 0, 0, NULL } },
 	{ TONE, .u.n = {"\x01%dx", 1, 0, 2, 0, 0, NULL } },



