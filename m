Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KDGGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:06:39 -0500
Received: from intranet.asianux.com ([58.214.24.6]:45268 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3KDGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:06:38 -0500
X-Spam-Score: -100.8
Message-ID: <52773930.2020808@asianux.com>
Date: Mon, 04 Nov 2013 14:05:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH v2] kernel/resource.c: use signed length comparing instead
 of position comparing
References: <52770EFA.5060809@asianux.com>
In-Reply-To: <52770EFA.5060809@asianux.com>
X-Forwarded-Message-Id: <52770EFA.5060809@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, forgot to cc linux-kernel.


-------- Original Message --------
Subject: [PATCH v2] kernel/resource.c: use signed length comparing instead of position comparing
Date: Mon, 04 Nov 2013 11:05:30 +0800
From: Chen Gang <gang.chen@asianux.com>
To: Toshi Kani <toshi.kani@hp.com>,  "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>, gong.chen@linux.intel.com, haokexin@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>

Theoretically, "addr + size" may be overflow (e.g. equal 0), so use
signed length comparing instead of position comparing.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 3f285dc..0783733 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1335,7 +1335,7 @@ int iomem_is_exclusive(u64 addr)
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
 		 */
-		if (p->start >= addr + size)
+		if ((s64)(p->start - addr) >= size)
 			break;
 		if (p->end < addr)
 			continue;
-- 
1.7.7.6


