Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3AXVPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:15:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:40125 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab3AXVOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 18/46] arm64: makefile: fix uname munging when setting ARCH on native machine
Date: Thu, 24 Jan 2013 13:12:56 -0800
Message-Id: <20130124211142.689606600@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f1b99392caf120d7533da260318fae0eb5053737 upstream.

By popular demand, arch/aarch64 is now known as arch/arm64. However,
uname -m (and indeed the GNU triplet) still use aarch64 as the machine
string.

This patch fixes native builds of both the kernel and perf tools by
updating the relevant Makefiles to munge the output of uname -m and
set the ARCH variable appropriately.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile            |    2 +-
 tools/perf/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -169,7 +169,7 @@ SUBARCH := $(shell uname -m | sed -e s/i
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ )
+				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 
 # Cross compiling and selecting different set of gcc/bin-utils
 # ---------------------------------------------------------------------------
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -58,7 +58,7 @@ ARCH ?= $(shell echo $(uname_M) | sed -e
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ )
+				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 NO_PERF_REGS := 1
 
 CC = $(CROSS_COMPILE)gcc


