Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3JaMC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:02:59 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41746 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640Ab3JaMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:02:58 -0400
From: <srinivas.kandagatla@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>, <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 1/2] bitops: introduce BITS_MASK macro
Date: Thu, 31 Oct 2013 11:53:50 +0000
Message-ID: <1383220430-18473-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
References: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch introduces BITS_MASK macro which creates a mask for a given
lsb and msb bit locations. The usage of masks spread over mutiple bits
is becoming very common for example with regmap_update_bits kind of
apis. Having a common macro for this makes much sense and is clean and
readable way to encode the mask rather than having an hex number for a
mask.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 include/linux/bitops.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..3ddce97 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -5,6 +5,7 @@
 #ifdef	__KERNEL__
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BITS_MASK(lsb, msb)	((BIT(msb - lsb + 1) - 1) << lsb)
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-- 
1.7.6.5

