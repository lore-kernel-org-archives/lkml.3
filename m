Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3FZCpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:45:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab3FZCpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Metcalf" <cmetcalf@tilera.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.488670597@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/26] tilepro: work around module link error with gcc 4.7
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 3cb3f839d306443f3d1e79b0bde1a2ad2c12b555 upstream.

gcc 4.7.x is emitting calls to __ffsdi2 where previously
it used to inline the appropriate ctz instructions.
While this needs to be fixed in gcc, it's also easy to avoid
having it cause build failures when building with those
compilers by exporting __ffsdi2 to modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/lib/exports.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -90,4 +90,6 @@ uint64_t __ashrdi3(uint64_t, unsigned in
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif

