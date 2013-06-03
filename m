Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3FCNtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:49:13 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:58685 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3FCNtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:49:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,793,1363132800"; 
   d="scan'208";a="5262208"
Message-ID: <1370267346.24512.6.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Josh Boyer <jwboyer@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Tirumala R Marri <tmarri@apm.com>,
        Rupjyoti Sarmah <rsarmah@apm.com>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 3 Jun 2013 14:49:06 +0100
In-Reply-To: <20130603133633.GA18391@zod>
References: <1370257224-23805-1-git-send-email-ian.campbell@citrix.com>
	 <20130603133633.GA18391@zod>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
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

Funnily enough the previous patch to this file (where I nabbed the
address from) was approximately that long ago ;-)

I've updated my local copy with your Ack with the correct address,
thanks.

I also corrected the "plarforms" typo which I just spotted...

Ian.

> >Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >Cc: Paul Mackerras <paulus@samba.org>
> >Cc: linuxppc-dev@lists.ozlabs.org
> >Cc: linux-kernel@vger.kernel.org
> 
> Acked-by: Josh Boyer <jwboyer@gmail.com>
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


