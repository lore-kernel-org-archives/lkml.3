Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3IXJKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:10:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23868 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3IXJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:10:49 -0400
X-IronPort-AV: E=Sophos;i="4.90,969,1371081600"; 
   d="scan'208";a="56739181"
Message-ID: <1380013846.23688.9.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Josh Boyer <jwboyer@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Tirumala R Marri <tmarri@apm.com>,
        Rupjyoti Sarmah <rsarmah@apm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 24 Sep 2013 10:10:46 +0100
In-Reply-To: <20130603133633.GA18391@zod>
References: <1370257224-23805-1-git-send-email-ian.campbell@citrix.com>
	 <20130603133633.GA18391@zod>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 09:36 -0400, Josh Boyer wrote:
> On Mon, Jun 03, 2013 at 12:00:24PM +0100, Ian Campbell wrote:
> >Currently I see:
> >  DTC     arch/powerpc/boot/kilauea.dtb
> >Warning (reg_format): "reg" property in /plb/ppc4xx-msi@C10000000 has invalid length (12 bytes) (#address-cells == 1, #size-cells == 1)
> >
> >It appears that unlike the other plarforms handled by 3fb7933850fa
> >"powerpc/4xx: Adding PCIe MSI support" this platform does not use address-cells=2.
> 
> Right, it's a 405, not a 440.  I should have caught that in the initial
> review.
> 
> >Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >Cc: Rupjyoti Sarmah <rsarmah@apm.com>
> >Cc: Tirumala R Marri <tmarri@apm.com>
> >Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> That address should bounce.  It hasn't been active in almost 2 years.
> 
> >Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >Cc: Paul Mackerras <paulus@samba.org>
> >Cc: linuxppc-dev@lists.ozlabs.org
> >Cc: linux-kernel@vger.kernel.org
> 
> Acked-by: Josh Boyer <jwboyer@gmail.com>

This still doesn't appear to be fixed v3.12-rc2. Ping?

> 
> >---
> > arch/powerpc/boot/dts/kilauea.dts |    2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> >index 1613d6e..5ba7f01 100644
> >--- a/arch/powerpc/boot/dts/kilauea.dts
> >+++ b/arch/powerpc/boot/dts/kilauea.dts
> >@@ -406,7 +406,7 @@
> > 
> > 		MSI: ppc4xx-msi@C10000000 {
> > 			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> >-			reg = < 0x0 0xEF620000 0x100>;
> >+			reg = <0xEF620000 0x100>;
> > 			sdr-base = <0x4B0>;
> > 			msi-data = <0x00000000>;
> > 			msi-mask = <0x44440000>;
> >-- 
> >1.7.10.4
> >
> >_______________________________________________
> >Linuxppc-dev mailing list
> >Linuxppc-dev@lists.ozlabs.org
> >https://lists.ozlabs.org/listinfo/linuxppc-dev


