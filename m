Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161653AbaKNTMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:12:35 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:39771 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161304AbaKNTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:12:33 -0500
X-SENDER-IP: [213.113.165.61]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQRAKhSZlTVcaU9Omdsb2JhbABbgw6BLoI2hQfNEgICAoEcFwEBAQEBAQUBAQEBIhY7hAIBAQEBAgEyASMTAQ8FCwgDEQMBAgolDwUZDAoMDgoJiDgNAdITAQEBAQEBAQEBAQEBAQEBARwYkQoHgy2BHgWZbYRegTWGY4pZiAc8MIJLAQEB
X-IPAS-Result: AiQRAKhSZlTVcaU9Omdsb2JhbABbgw6BLoI2hQfNEgICAoEcFwEBAQEBAQUBAQEBIhY7hAIBAQEBAgEyASMTAQ8FCwgDEQMBAgolDwUZDAoMDgoJiDgNAdITAQEBAQEBAQEBAQEBAQEBARwYkQoHgy2BHgWZbYRegTWGY4pZiAc8MIJLAQEB
X-IronPort-AV: E=Sophos;i="5.07,387,1413237600"; 
   d="scan'208";a="816846843"
Date: Fri, 14 Nov 2014 20:11:57 +0100
From: Henrik Rydberg <rydberg@euromail.se>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, ia64: Do not lose track of the EFI default VGA
 device
Message-ID: <20141114191157.GA1648@polaris.bitmath.org>
References: <1415969610-1469-1-git-send-email-rydberg@euromail.se>
 <20141114154252.0fb66bba@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141114154252.0fb66bba@pluto.restena.lu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

> So it would need to at least be select VGA_ARB if (PCI && !S390)
> in order to not have broken kernel configuration (in more or less
> exotic cases) while depends on VGA_ARB would be the only correct option
> if the rule 'select only allowed for leafs' is enforced.

Here is a tested patch that does just that, thanks for the suggestion.

Henrik

>From 43c16bbc7adbcb17aac73d09f046bf2779771c4c Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 14 Nov 2014 20:01:21 +0100
Subject: [PATCH v2] x86, ia64: Do not lose track of the EFI default VGA device
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 20cde694 in the 3.17 merge window, the EFI framebuffer
depends on the VGA arbitration layer. However, the configuration does
not reflect this, which leads to a hard-to-find bug when FB_EFI is
configured without VGA_ARB. Add a select clause to remedy this.

Cc: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/video/fbdev/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index c7bf606..1615a1b 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -761,6 +761,7 @@ config FB_EFI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGA_ARB if (PCI && !S390)
 	help
 	  This is the EFI frame buffer device driver. If the firmware on
 	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
-- 
2.1.3

