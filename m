Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3FYSou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3FYSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 02/17] tilepro: work around module link error with gcc 4.7
Date: Tue, 25 Jun 2013 11:39:17 -0700
Message-Id: <20130625183915.726448651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 3cb3f839d306443f3d1e79b0bde1a2ad2c12b555 upstream.

gcc 4.7.x is emitting calls to __ffsdi2 where previously
it used to inline the appropriate ctz instructions.
While this needs to be fixed in gcc, it's also easy to avoid
having it cause build failures when building with those
compilers by exporting __ffsdi2 to modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/lib/exports.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -89,4 +89,6 @@ uint64_t __ashrdi3(uint64_t, unsigned in
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif


