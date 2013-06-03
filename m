Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3FCNgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:36:54 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42512 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3FCNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:36:52 -0400
Date: Mon, 3 Jun 2013 09:36:33 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Tirumala R Marri <tmarri@apm.com>,
        Rupjyoti Sarmah <rsarmah@apm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
Message-ID: <20130603133633.GA18391@zod>
References: <1370257224-23805-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370257224-23805-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 12:00:24PM +0100, Ian Campbell wrote:
>Currently I see:
>  DTC     arch/powerpc/boot/kilauea.dtb
>Warning (reg_format): "reg" property in /plb/ppc4xx-msi@C10000000 has invalid length (12 bytes) (#address-cells == 1, #size-cells == 1)
>
>It appears that unlike the other plarforms handled by 3fb7933850fa
>"powerpc/4xx: Adding PCIe MSI support" this platform does not use address-cells=2.

Right, it's a 405, not a 440.  I should have caught that in the initial
review.

>Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>Cc: Rupjyoti Sarmah <rsarmah@apm.com>
>Cc: Tirumala R Marri <tmarri@apm.com>
>Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>

That address should bounce.  It hasn't been active in almost 2 years.

>Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>Cc: Paul Mackerras <paulus@samba.org>
>Cc: linuxppc-dev@lists.ozlabs.org
>Cc: linux-kernel@vger.kernel.org

Acked-by: Josh Boyer <jwboyer@gmail.com>

>---
> arch/powerpc/boot/dts/kilauea.dts |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
>index 1613d6e..5ba7f01 100644
>--- a/arch/powerpc/boot/dts/kilauea.dts
>+++ b/arch/powerpc/boot/dts/kilauea.dts
>@@ -406,7 +406,7 @@
> 
> 		MSI: ppc4xx-msi@C10000000 {
> 			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
>-			reg = < 0x0 0xEF620000 0x100>;
>+			reg = <0xEF620000 0x100>;
> 			sdr-base = <0x4B0>;
> 			msi-data = <0x00000000>;
> 			msi-mask = <0x44440000>;
>-- 
>1.7.10.4
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev
