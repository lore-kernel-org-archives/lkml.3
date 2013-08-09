Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab3HIB7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967657Ab3HIB7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 082/102] s390/bitops: fix find_next_bit_left
Date: Thu,  8 Aug 2013 18:57:58 -0700
Message-Id: <20130809015029.582087780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 3b0040a47ad63f7147e9e7d2febb61a3b564bb90 upstream.

The find_next_bit_left function is broken if used with an offset which
is not a multiple of 64. The shift to mask the bits of a 64-bit word
not to search is in the wrong direction, the result can be either a
bit found smaller than the offset or failure to find a set bit.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -693,7 +693,7 @@ static inline int find_next_bit_left(con
 	size -= offset;
 	p = addr + offset / BITS_PER_LONG;
 	if (bit) {
-		set = __flo_word(0, *p & (~0UL << bit));
+		set = __flo_word(0, *p & (~0UL >> bit));
 		if (set >= size)
 			return size + offset;
 		if (set < BITS_PER_LONG)


