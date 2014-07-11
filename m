Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaGKOFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29322 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaGKOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:56 -0400
X-AuditID: cbfee61b-f79f86d00000144c-05-53bfef068541
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH/RFC v4 07/21] of: add of_node_ncmp wrapper
Date: Fri, 11 Jul 2014 16:04:10 +0200
Message-id: <1405087464-13762-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQV329/uDDabfYrHYOGM9q8WHplZm
	i/lHzrFaHPizg9Gi9+pzRouzTW/YLS7vmsNmsfXNOkaLng1bWS2efDzN4sDl0fOmhdXjzrU9
	bB5/u6Ywe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGj55dzAVT2Cu+3FzN3MDYwtbFyMkh
	IWAiceDZf1YIW0ziwr31QHEuDiGB6YwS948vY4Jw2pkkNm3dxQRSxSZgKPHzxWswW0SgXKLn
	/TOwDmaBF4wSO5vXMYIkhAWsJA6caQEbyyKgKnFuwQJ2EJtXwENi/oJFLF2MHEDrFCTmTLIB
	CXMKeEoc7L8JdpEQUMnDtSfYJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHHTP
	pHcwrmqwOMQowMGoxMN7Ys2+YCHWxLLiytxDjBIczEoivFff7A8W4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwOja96nu1ecbzteYWj7ctDtfM+/BF7W3
	hjWXt+z5WDOb2XRmwcYNB7lvlJ/hMrpV6lm5cLaYq+wRi8NcQk8iF1fqPX+rmHrqv/GvzzMP
	yqxhOcPUdeLaszjjqkca926xB39Um5npba69KU6r58zjc3U3hC69cK0qOua649k+a94yI7mU
	qWoFMrVKLMUZiYZazEXFiQDQ+pfdNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrapper for strnicmp is required for checking whether a node has
expected prefix.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>
---
 include/linux/of.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 692b56c..9a53eea 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -199,6 +199,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
 #define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
 #endif
 
 /* flag descriptions */
-- 
1.7.9.5

