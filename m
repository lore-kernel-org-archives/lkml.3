Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3H1H07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:26:59 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48914 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H1H06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130814200442.GA20372@8bytes.org>
References: <1376509818-22163-1-git-send-email-joro@8bytes.org>
	<20130814195701.GY23006@n2100.arm.linux.org.uk>
	<20130814200442.GA20372@8bytes.org>
Date: Wed, 28 Aug 2013 09:26:57 +0200
Message-ID: <CACRpkdZVAG=0zvLbR4E+UEjHUaYOgqUxsfGoZybPtm1DwDAJ1Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: integrator: Make sure INTEGRATOR_AP depends on PCI
From: Linus Walleij <linus.walleij@linaro.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 10:04 PM, Joerg Roedel <joro@8bytes.org> wrote:

> So when integrator does not depend on PCI this diff is more appropriate?
>
> diff --git a/arch/arm/mach-integrator/pci_v3.h b/arch/arm/mach-integrator/pci_v3.h
> index 755fd29..51738e0 100644
> --- a/arch/arm/mach-integrator/pci_v3.h
> +++ b/arch/arm/mach-integrator/pci_v3.h
> @@ -1,2 +1,9 @@
> -/* Simple oneliner include to the PCIv3 early init */
> +/* Define PCIv3 early init */
> +#ifdef CONFIG_PCI
>  extern int pci_v3_early_init(void);
> +#else
> +static inline int pci_v3_early_init(void)
> +{
> +       return 0;
> +}
> +#endif

Yes.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

And can you please create and send a proper patch with this
content to arm@kernel.org and the mailing list on CC, with
a request for the ARM SoC maintainers to apply it directly
as a fix?

You might as well add Cc: stable@vger.kernel.org as well.

Yours,
Linus Walleij
