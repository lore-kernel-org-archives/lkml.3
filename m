Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaLEI5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:57:46 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5487 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbaLEI5p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:57:45 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>
Date: Fri, 5 Dec 2014 16:57:38 +0800
Subject: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Topic: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Index: AdAQaYTRBP+XSfzeRTCVl77g86jARg==
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add KPF_ZERO_PAGE flag for zero_page,
so that userspace process can notice zero_page from
/proc/kpageflags, and then do memory analysis more accurately.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 fs/proc/page.c                         | 3 +++
 include/uapi/linux/kernel-page-flags.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 1e3187d..120dbf7 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -136,6 +136,9 @@ u64 stable_page_flags(struct page *page)
 	if (PageBalloon(page))
 		u |= 1 << KPF_BALLOON;
 
+	if (is_zero_pfn(page_to_pfn(page)))
+		u |= 1 << KPF_ZERO_PAGE;
+
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
index 2f96d23..a6c4962 100644
--- a/include/uapi/linux/kernel-page-flags.h
+++ b/include/uapi/linux/kernel-page-flags.h
@@ -32,6 +32,7 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 #define KPF_BALLOON		23
+#define KPF_ZERO_PAGE		24
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
-- 
2.1.3
