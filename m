Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaJOOqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaJOOqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:46:13 -0400
Date: Wed, 15 Oct 2014 10:46:03 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, aubrey.li@linux.intel.com
Subject: x86: Make Atom PMC driver configurable.
Message-ID: <20141015144603.GA19944@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	aubrey.li@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atom PMC driver is always built-in, regardless of whether
the kernel being built is going to be run on an Atom (or even Intel) CPU.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e88e07c..04280177c1e2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2485,7 +2485,7 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config PMC_ATOM
-	def_bool y
+	tristate "Intel Atom SOC power management controller driver"
         depends on PCI
 
 source "net/Kconfig"
