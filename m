Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbbAZMGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:06:45 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:45972 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbbAZMG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:06:28 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: 8253.h: use usual style for single-line comments
Date: Mon, 26 Jan 2015 12:06:07 +0000
Message-Id: <1422273967-16407-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422273967-16407-1-git-send-email-abbotti@mev.co.uk>
References: <1422273967-16407-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one space after the opening and one space before the closing of the
comment.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8253.h | 48 +++++++++++++++++------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index 0d9aec0..51b9c8d 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -116,7 +116,7 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 	}
 
 	*nanosec = div1 * div2 * i8253_osc_base;
-	/*  masking is done since counter maps zero to 0x10000 */
+	/* masking is done since counter maps zero to 0x10000 */
 	*d1 = div1 & 0xffff;
 	*d2 = div2 & 0xffff;
 }
@@ -161,12 +161,12 @@ static inline int i8254_load(unsigned long base_address, unsigned int regshift,
 		return -1;
 
 	byte = counter_number << 6;
-	byte |= 0x30;		/*  load low then high byte */
-	byte |= (mode << 1);	/*  set counter mode */
+	byte |= 0x30;		/* load low then high byte */
+	byte |= (mode << 1);	/* set counter mode */
 	outb(byte, base_address + (i8254_control_reg << regshift));
-	byte = count & 0xff;	/*  lsb of counter value */
+	byte = count & 0xff;	/* lsb of counter value */
 	outb(byte, base_address + (counter_number << regshift));
-	byte = (count >> 8) & 0xff;	/*  msb of counter value */
+	byte = (count >> 8) & 0xff;	/* msb of counter value */
 	outb(byte, base_address + (counter_number << regshift));
 
 	return 0;
@@ -190,18 +190,18 @@ static inline int i8254_mm_load(void __iomem *base_address,
 		return -1;
 
 	byte = counter_number << 6;
-	byte |= 0x30;		/*  load low then high byte */
-	byte |= (mode << 1);	/*  set counter mode */
+	byte |= 0x30;		/* load low then high byte */
+	byte |= (mode << 1);	/* set counter mode */
 	writeb(byte, base_address + (i8254_control_reg << regshift));
-	byte = count & 0xff;	/*  lsb of counter value */
+	byte = count & 0xff;	/* lsb of counter value */
 	writeb(byte, base_address + (counter_number << regshift));
-	byte = (count >> 8) & 0xff;	/*  msb of counter value */
+	byte = (count >> 8) & 0xff;	/* msb of counter value */
 	writeb(byte, base_address + (counter_number << regshift));
 
 	return 0;
 }
 
-/* Returns 16 bit counter value, should work for 8253 also.*/
+/* Returns 16 bit counter value, should work for 8253 also. */
 static inline int i8254_read(unsigned long base_address, unsigned int regshift,
 			     unsigned int counter_number)
 {
@@ -211,13 +211,13 @@ static inline int i8254_read(unsigned long base_address, unsigned int regshift,
 	if (counter_number > 2)
 		return -1;
 
-	/*  latch counter */
+	/* latch counter */
 	byte = counter_number << 6;
 	outb(byte, base_address + (i8254_control_reg << regshift));
 
-	/*  read lsb */
+	/* read lsb */
 	ret = inb(base_address + (counter_number << regshift));
-	/*  read msb */
+	/* read msb */
 	ret += inb(base_address + (counter_number << regshift)) << 8;
 
 	return ret;
@@ -233,13 +233,13 @@ static inline int i8254_mm_read(void __iomem *base_address,
 	if (counter_number > 2)
 		return -1;
 
-	/*  latch counter */
+	/* latch counter */
 	byte = counter_number << 6;
 	writeb(byte, base_address + (i8254_control_reg << regshift));
 
-	/*  read lsb */
+	/* read lsb */
 	ret = readb(base_address + (counter_number << regshift));
-	/*  read msb */
+	/* read msb */
 	ret += readb(base_address + (counter_number << regshift)) << 8;
 
 	return ret;
@@ -255,9 +255,9 @@ static inline void i8254_write(unsigned long base_address,
 	if (counter_number > 2)
 		return;
 
-	byte = count & 0xff;	/*  lsb of counter value */
+	byte = count & 0xff;	/* lsb of counter value */
 	outb(byte, base_address + (counter_number << regshift));
-	byte = (count >> 8) & 0xff;	/*  msb of counter value */
+	byte = (count >> 8) & 0xff;	/* msb of counter value */
 	outb(byte, base_address + (counter_number << regshift));
 }
 
@@ -271,9 +271,9 @@ static inline void i8254_mm_write(void __iomem *base_address,
 	if (counter_number > 2)
 		return;
 
-	byte = count & 0xff;	/*  lsb of counter value */
+	byte = count & 0xff;	/* lsb of counter value */
 	writeb(byte, base_address + (counter_number << regshift));
-	byte = (count >> 8) & 0xff;	/*  msb of counter value */
+	byte = (count >> 8) & 0xff;	/* msb of counter value */
 	writeb(byte, base_address + (counter_number << regshift));
 }
 
@@ -297,8 +297,8 @@ static inline int i8254_set_mode(unsigned long base_address,
 		return -1;
 
 	byte = counter_number << 6;
-	byte |= 0x30;		/*  load low then high byte */
-	byte |= mode;		/*  set counter mode and BCD|binary */
+	byte |= 0x30;		/* load low then high byte */
+	byte |= mode;		/* set counter mode and BCD|binary */
 	outb(byte, base_address + (i8254_control_reg << regshift));
 
 	return 0;
@@ -317,8 +317,8 @@ static inline int i8254_mm_set_mode(void __iomem *base_address,
 		return -1;
 
 	byte = counter_number << 6;
-	byte |= 0x30;		/*  load low then high byte */
-	byte |= mode;		/*  set counter mode and BCD|binary */
+	byte |= 0x30;		/* load low then high byte */
+	byte |= mode;		/* set counter mode and BCD|binary */
 	writeb(byte, base_address + (i8254_control_reg << regshift));
 
 	return 0;
-- 
2.1.4

