Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3GBLPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:15:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3GBLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 25/50] tilepro: work around module link error with gcc 4.7
Date: Tue,  2 Jul 2013 12:07:13 +0100
Message-Id: <1372763258-20664-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 3cb3f839d306443f3d1e79b0bde1a2ad2c12b555 upstream.

gcc 4.7.x is emitting calls to __ffsdi2 where previously
it used to inline the appropriate ctz instructions.
While this needs to be fixed in gcc, it's also easy to avoid
having it cause build failures when building with those
compilers by exporting __ffsdi2 to modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/tile/lib/exports.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index dd5f0a3..b05d919 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -82,4 +82,6 @@ uint64_t __ashrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif
-- 
1.8.1.2

