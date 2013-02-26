Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3B0AHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:07:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab3BZX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/53] drivers/video/backlight/adp88?0_bl.c: fix resume
Date: Tue, 26 Feb 2013 15:57:49 -0800
Message-Id: <20130226235621.931895509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 5eb02c01bd1f3ef195989ab05e835e2b0711b5a9 upstream.

Clearing the NSTBY bit in the control register also automatically clears
the BLEN bit.  So we need to make sure to set it again during resume,
otherwise the backlight will stay off.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/backlight/adp8860_bl.c |    2 +-
 drivers/video/backlight/adp8870_bl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -793,7 +793,7 @@ static int adp8860_i2c_suspend(struct i2
 
 static int adp8860_i2c_resume(struct i2c_client *client)
 {
-	adp8860_set_bits(client, ADP8860_MDCR, NSTBY);
+	adp8860_set_bits(client, ADP8860_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -968,7 +968,7 @@ static int adp8870_i2c_suspend(struct i2
 
 static int adp8870_i2c_resume(struct i2c_client *client)
 {
-	adp8870_set_bits(client, ADP8870_MDCR, NSTBY);
+	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
 
 	return 0;
 }


