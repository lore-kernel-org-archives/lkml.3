Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaIKNSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:18:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51488 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Simek" <monstr@monstr.eu>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.840214509@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 131/131] microblaze: Fix makefile to work with latest
 toolchain
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <monstr@monstr.eu>

commit 00708d421a22a0f82de2dbb91ca6213b3dcc5267 upstream.

When building with latest binutils, vmlinux includes
some sections which need to be stripped out when building
the binary image.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/microblaze/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 0c796cf..34940c8 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -8,7 +8,7 @@ obj-y += linked_dtb.o
 
 targets := linux.bin linux.bin.gz simpleImage.%
 
-OBJCOPYFLAGS := -O binary
+OBJCOPYFLAGS := -R .note -R .comment -R .note.gnu.build-id -O binary
 
 # Ensure system.dtb exists
 $(obj)/linked_dtb.o: $(obj)/system.dtb

