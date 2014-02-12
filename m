Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaBLWqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:46:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59987 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaBLWqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:46:06 -0500
Date: Wed, 12 Feb 2014 14:43:57 -0800
From: Kees Cook <keescook@chromium.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] ARM: mm: fix reporting of read-only PMD bits
Message-ID: <20140212224357.GA4286@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On non-LPAE, read-only PMD bits are defined with the combination
"PMD_SECT_APX | PMD_SECT_AP_WRITE". Adjusted the bit masks to correctly
detect this.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - reorder bits, suggested by Olof Johansson.
---
 arch/arm/mm/dump.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 2b3a56414271..2b342177f5de 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -123,19 +123,19 @@ static const struct prot_bits section_bits[] = {
 #ifndef CONFIG_ARM_LPAE
 	/* These are approximate */
 	{
-		.mask	= PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
-		.val	= 0,
+		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
+		.val	= PMD_SECT_APX | PMD_SECT_AP_WRITE,
 		.set	= "    ro",
 	}, {
-		.mask	= PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
+		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val	= PMD_SECT_AP_WRITE,
 		.set	= "    RW",
 	}, {
-		.mask	= PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
+		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val	= PMD_SECT_AP_READ,
 		.set	= "USR ro",
 	}, {
-		.mask	= PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
+		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val	= PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.set	= "USR RW",
 #else
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
