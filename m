Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJ0FZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:41 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:45888 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbaJ0FZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:5007:6119:6261:7903:10004:10848:11026:11658:11914:12043:12438:12517:12519:12555:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: word08_4e2bb19059f36
X-Filterd-Recvd-Size: 2042
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Sterba <dsterba@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 09/11] tty: ipwireless: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:25:05 -0700
Message-Id: <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the masks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/ipwireless/hardware.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index 2c14842..5c77e1e 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -378,9 +378,9 @@ static void swap_packet_bitfield_to_le(unsigned char *data)
 	/*
 	 * transform bits from aa.bbb.ccc to ccc.bbb.aa
 	 */
-	ret |= tmp & 0xc0 >> 6;
-	ret |= tmp & 0x38 >> 1;
-	ret |= tmp & 0x07 << 5;
+	ret |= (tmp & 0xc0) >> 6;
+	ret |= (tmp & 0x38) >> 1;
+	ret |= (tmp & 0x07) << 5;
 	*data = ret & 0xff;
 #endif
 }
@@ -393,9 +393,9 @@ static void swap_packet_bitfield_from_le(unsigned char *data)
 	/*
 	 * transform bits from ccc.bbb.aa to aa.bbb.ccc
 	 */
-	ret |= tmp & 0xe0 >> 5;
-	ret |= tmp & 0x1c << 1;
-	ret |= tmp & 0x03 << 6;
+	ret |= (tmp & 0xe0) >> 5;
+	ret |= (tmp & 0x1c) << 1;
+	ret |= (tmp & 0x03) << 6;
 	*data = ret & 0xff;
 #endif
 }
-- 
2.1.2

