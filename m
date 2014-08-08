Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbaHHV6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:58:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaHHVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 26/39] sparc64: Fix range check in kern_addr_valid().
Date: Fri,  8 Aug 2014 14:35:12 -0700
Message-Id: <20140808213356.090718551@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit ee73887e92a69ae0a5cda21c68ea75a27804c944 ]

In commit b2d438348024b75a1ee8b66b85d77f569a5dfed8 ("sparc64: Make
PAGE_OFFSET variable."), the MAX_PHYS_ADDRESS_BITS value was increased
(to 47).

This constant reference to '41UL' was missed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -916,7 +916,7 @@ static inline bool kern_addr_valid(unsig
 {
 	unsigned long paddr = __pa(addr);
 
-	if ((paddr >> 41UL) != 0UL)
+	if ((paddr >> MAX_PHYS_ADDRESS_BITS) != 0UL)
 		return false;
 	return test_bit(paddr >> 22, sparc64_valid_addr_bitmap);
 }


