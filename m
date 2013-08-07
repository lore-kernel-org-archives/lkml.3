Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3HGKXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:23:48 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56319 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab3HGKXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:23:46 -0400
Date: Wed, 7 Aug 2013 12:17:03 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 04/26] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <3c3bda8fd9406d752a710aa75de613463b712bbe.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a number
of amba drivers and needs to activate core bus support.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52432ab..490b001 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -554,6 +554,7 @@ config STA2X11
 	select SWIOTLB
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_AMBA
 	default n
 	---help---
 	  This adds support for boards based on the STA2X11 IO-Hub,
@@ -2255,6 +2256,9 @@ config TS5500
 
 endif # X86_32
 
+config ARM_AMBA
+        bool
+
 config AMD_NB
 	def_bool y
 	depends on CPU_SUP_AMD && PCI
-- 
1.7.7.2
