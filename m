Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaKLBZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKLBZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ulrich Eckhardt <uli@uli-eckhardt.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.17 119/319] media: imon: fix other RC type protocol support
Date: Wed, 12 Nov 2014 10:14:17 +0900
Message-Id: <20141112011012.310156048@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>

commit d358aefdc0cc92b16ced449f998dbad639db6809 upstream.

With kernel 3.17 the imon remote control for device 15c2:0034 does not
work anymore, which uses the OTHER protocol. Only the front panel
buttons which uses the RC6 protocol are working.

Adds the missing comparison for the RC_BIT_OTHER.

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/imon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1579,7 +1579,8 @@ static void imon_incoming_packet(struct
 		if (press_type == 0)
 			rc_keyup(ictx->rdev);
 		else {
-			if (ictx->rc_type == RC_BIT_RC6_MCE)
+			if (ictx->rc_type == RC_BIT_RC6_MCE ||
+			    ictx->rc_type == RC_BIT_OTHER)
 				rc_keydown(ictx->rdev,
 					   ictx->rc_type == RC_BIT_RC6_MCE ? RC_TYPE_RC6_MCE : RC_TYPE_OTHER,
 					   ictx->rc_scancode, ictx->rc_toggle);


