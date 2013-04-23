Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3DWSD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:03:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42749 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3DWSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:03:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185/6gxZxmhIc45lyUyhtwo
Date: Tue, 23 Apr 2013 11:03:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Afzal Mohammed <afzal@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 21/21] mtd: omap2: allow bulding as a module
Message-ID: <20130423180320.GJ10155@atomide.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-22-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366734653-488286-22-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130423 09:37]:
> The omap2 nand device driver calls into the the elm code, which can
> be a loadable module, and in that case it cannot be built-in itself.
> I can see no reason why the omap2 driver cannot also be a module,
> so let's make the option "tristate" in Kconfig to fix this allmodconfig
> build error:
> 
> ERROR: "elm_config" [drivers/mtd/nand/omap2.ko] undefined!
> ERROR: "elm_decode_bch_error_page" [drivers/mtd/nand/omap2.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Afzal Mohammed <afzal@ti.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/nand/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 81bf5e5..106b55e 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -109,7 +109,7 @@ config MTD_NAND_OMAP2
>  
>  config MTD_NAND_OMAP_BCH
>  	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
> -	bool "Enable support for hardware BCH error correction"
> +	tristate "Enable support for hardware BCH error correction"
>  	default n
>  	select BCH
>  	select BCH_CONST_PARAMS

Acked-by: Tony Lindgren <tony@atomide.com>

While at it, you could also drop the "default n" as that's
the default anyways.

Regards,

Tony
