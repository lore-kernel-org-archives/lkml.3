Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3KTRnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:43:47 -0500
Received: from 4.mo5.mail-out.ovh.net ([178.33.111.247]:53106 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906Ab3KTRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:43:46 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 12:43:46 EST
Date: Wed, 20 Nov 2013 18:27:22 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/9] ARM: at91/dt: add new at91rm9200ek_mmc board
Message-ID: <20131120172722.GJ14627@ns203013.ovh.net>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
 <1377693456-11133-1-git-send-email-b.brezillon@overkiz.com>
 <20131120150255.GH14627@ns203013.ovh.net>
 <528CE3E6.1040802@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CE3E6.1040802@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 17324503342588078969
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:31 Wed 20 Nov     , boris brezillon wrote:
> On 20/11/2013 16:02, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >On 14:37 Wed 28 Aug     , Boris BREZILLON wrote:
> >>Add a new at91rm9200ek_mmc board (based on at91rm9200ek board) which enables
> >>mmc0/slot0.
> >no for multiple dts
> >
> >this need to handle at user space level
> 
> You mean, by controlling the regulator using the sysfs interface, or
> by loading
> only the appropriate driver ?
load the partial dts via userspace
> 
> What if both drivers are loaded (or not compiled as modules) ?
> This will lead to one device being unusable (and maybe even worst)...
> 
this will never be the case

Best Regards,
J.
> Please explain what you had in mind ?
> 
> >
> >Best Regards,
> >J.
> >>Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> >>---
> >>  arch/arm/boot/dts/at91rm9200ek_mmc.dts |   23 +++++++++++++++++++++++
> >>  1 file changed, 23 insertions(+)
> >>  create mode 100644 arch/arm/boot/dts/at91rm9200ek_mmc.dts
> >>
> >>diff --git a/arch/arm/boot/dts/at91rm9200ek_mmc.dts b/arch/arm/boot/dts/at91rm9200ek_mmc.dts
> >>new file mode 100644
> >>index 0000000..c87a861
> >>--- /dev/null
> >>+++ b/arch/arm/boot/dts/at91rm9200ek_mmc.dts
> >>@@ -0,0 +1,23 @@
> >>+/*
> >>+ * at91rm9200ek.dts - Device Tree file for Atmel AT91RM9200 evaluation kit with
> >>+ *                    an MMC slot
> >>+ *
> >>+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> >>+ *
> >>+ * Licensed under GPLv2 only
> >>+ */
> >>+/dts-v1/;
> >>+#include "at91rm9200ek.dts"
> >>+
> >>+/ {
> >>+	model = "Atmel AT91RM9200 evaluation kit with MMC slot";
> >>+	compatible = "atmel,at91rm9200ek-mmc", "atmel,at91rm9200ek", "atmel,at91rm9200";
> >>+
> >>+	ahb {
> >>+		apb {
> >>+			mmc0: mmc@fffb4000 {
> >>+				status = "okay";
> >>+			};
> >>+		};
> >>+	};
> >>+};
> >>-- 
> >>1.7.9.5
> >>
> 
