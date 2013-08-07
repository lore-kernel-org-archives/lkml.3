Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3HGKYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:24:05 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56332 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab3HGKYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:24:02 -0400
Date: Wed, 7 Aug 2013 12:17:25 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 06/26] x86 STA2X11: select devicetree related config items.
Message-ID: <7db4ee60cebbe7e94353da2963bae4b2446e1215.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects some config items needed for adding device tree support
to STA2X11 based machines. In particular:

* OF_DYNAMIC is needed to use of_detach_node() and avoid instantiating
  the same node twice.

* IRQ_DOMAIN is needed because irq_of_parse_and_map() needs
  irq_create_of_mapping(), which is part of the irqdomain stuff.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 490b001..0a779eb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -555,6 +555,10 @@ config STA2X11
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
+	select OF
+	select OF_EARLY_FLATTREE
+	select OF_DYNAMIC
+	select IRQ_DOMAIN
 	default n
 	---help---
 	  This adds support for boards based on the STA2X11 IO-Hub,
-- 
1.7.7.2
