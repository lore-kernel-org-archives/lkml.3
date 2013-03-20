Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab3CTQ05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:26:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37180 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932417Ab3CTQ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:26:55 -0400
Message-ID: <1363796814.16270.36.camel@joe-AO722>
Subject: [PATCH] CodingStyle: Add tab indentation avoidance tips
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 09:26:54 -0700
In-Reply-To: <20130320152951.GO21522@ZenIV.linux.org.uk>
References: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
	 <20130320124753.GZ9138@mwanda> <20130320152951.GO21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Al's comments in from https://lkml.org/lkml/2013/3/20/345

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index e00b8f0..c4ba183 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -836,6 +836,141 @@ next instruction in the assembly output:
 	     : /* outputs */ : /* inputs */ : /* clobbers */);
 
 
+		Chapter 20:
+
+Tips to avoid overly tab indented code.
+
+Tip 1:
+	if (foo) {
+		A /* two lines */
+	} else {
+		B /* huge pile of shite */
+	}
+	return result;
+
+is equivalent to
+
+	if (foo) {
+		A
+		return result;
+	}
+	B
+	return result;
+
+Tip 2:
+	while (1) {
+		A	/* a couple of lines */
+		if (foo) {
+			break;
+		} else {
+			B /* huge pile of shite */
+		}
+	}
+
+is equivalent to
+
+	while (1) {
+		A
+		if (foo)
+			break;
+		B
+	}
+
+Tip 3:
+	while (1) {
+		A       /* moderate pile of shite, assigning foo */
+		if (foo) {
+			B /* huge pile of shite */
+		}
+	}
+
+is equivalent to
+
+	while (1) {
+		A
+		if (!foo)
+			continue;
+		B
+	}
+
+Tip 4:
+
+functions are there for purpose.  When you have two identical piles of
+garbage (avert your eyes, or risk taking another look at your dinner)
+such as
+				int unit, sign, min;
+				unit =
+				    (data.value >> 10) &
+				    0x7;
+				sign =
+				    (data.value >> 13) &
+				    0x1;
+				min =
+				    (data.value >> 14) &
+				    0xfffff;
+
+				switch (unit) {
+				case 0:{
+						min =
+						    min
+						    *
+						    1000000;
+					}
+					break;
+				case 1:{
+						min =
+						    min
+						    *
+						    1000;
+					}
+					break;
+				case 2:{
+						min =
+						    min
+						    * 1;
+					}
+					break;
+				}
+				if (sign)
+					min = -min;
+
+you just might consider turning that pile of excrements into a helper
+function.  Incidentally, min = min * 1 is somewhat, er, pointless...
+
+Tip 5:
+	for (i = 0; i <= 4; i++) {
+	{
+		switch (i) {
+		case 0: c = non_NULL_1; ... break;
+		case 1: c = non_NULL_2; ... break;
+		case 2: c = non_NULL_3; ... break;
+		case 3: c = non_NULL_4; ... break;
+		case 4: c = non_NULL_5; ... break;
+		default: c = NULL; break;
+		}
+		if (c) {
+			pile_of_shite
+		}
+	}
+might, perhaps, be taking defensive programming a bit too far...
+
+Tip 6:
+The Vogon whose brain has produced that code up had been brought up on Pascal,
+Ada or something worse, and had been badly traumatized by semantics of switch
+and break.
+	switch (foo) {
+		case 0: {
+			bar = baz;
+		} break;
+		case 1: {
+		.....
+	}
+	is not quite conventional for C.
+
+Tip 7:
+Code flow is down, not across...
+
+
 
 		Appendix I: References
 



