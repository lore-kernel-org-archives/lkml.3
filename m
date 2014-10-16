Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaJPCTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJPCTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:19:19 -0400
Date: Wed, 15 Oct 2014 22:18:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        aubrey.li@linux.intel.com
Subject: [Patch v2] x86: Make Atom PMC driver configurable.
Message-ID: <20141016021859.GA12042@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Felipe Balbi <balbi@ti.com>, x86@kernel.org,
	aubrey.li@linux.intel.com
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
 <20141015145924.GA21199@redhat.com>
 <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atom PMC driver is always built-in, regardless of whether
the kernel being built is going to be run on an Atom (or even Intel) CPU.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: aubrey.li@linux.intel.com

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e88e07c..b4dfd96aeea8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2485,7 +2485,8 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config PMC_ATOM
-	def_bool y
+	tristate "Intel Atom SOC power management controller driver"
+	default y
         depends on PCI
 
 source "net/Kconfig"
