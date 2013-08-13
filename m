Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab3HMQMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab3HMP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:26 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=c6g1m4iWErUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4tB3IJ9jJXwA:10 a=9AzMRrQhAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=SxxB86fLhQ4A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.320648940@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>, <stable@kernel.org>
Subject: [04/88] tilepro: work around module link error with gcc 4.7
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0004-tilepro-work-around-module-link-error-with-gcc-4.7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

[ Upstream commit 3cb3f839d306443f3d1e79b0bde1a2ad2c12b555 ]

gcc 4.7.x is emitting calls to __ffsdi2 where previously
it used to inline the appropriate ctz instructions.
While this needs to be fixed in gcc, it's also easy to avoid
having it cause build failures when building with those
compilers by exporting __ffsdi2 to modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/tile/lib/exports.c |    2 ++
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
1.7.10.4


