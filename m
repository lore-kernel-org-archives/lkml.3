Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaKZVdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:33:03 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53696 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaKZVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:33:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Gerlach <d-gerlach@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Russ Dill <russ.dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Anson.Huang@freescale.com, Russ Dill <Russ.Dill@ti.com>
Subject: Re: [RFC PATCH 1/2] asm-generic: io: Add exec versions of ioremap
Date: Wed, 26 Nov 2014 22:32:47 +0100
Message-ID: <2060921.TrTof4X6qj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cb5e9dd7bd71b13551cd3f32f28feb405ea9fcdd.1417029918.git.d-gerlach@ti.com>
References: <cover.1417029918.git.d-gerlach@ti.com> <cb5e9dd7bd71b13551cd3f32f28feb405ea9fcdd.1417029918.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IyED4T9aOvA/vJlfImMyb0lFTlWmSC+RRMSW53vUJMA
 mrY2JDRJunpnGwMJhwcIkMY86ErSiU7eAJMvJpqVUSKhSOG2c1
 uVBNakuK2keyJuaNPtKrE5PiJE1F6xpPMonw2ON19qmnPzU/G0
 392f61E9wOFfDG8IV5JZm0mbYmLj7bGpnCwIYcl22At1m/35DS
 fU3tneL9U8RbYMAFLxBUjTOrSV7PeIqbE3BuSlkpLsyOx8C+Zx
 UZnR/PfzbVstCyNKjPvoa/bsaUwc8JjFUom1YHBxT2NezGVFQQ
 AIjf8fYpOo6TiAHmODFehlkVyD2evY/qlK5PN8zEDDVV/wPd8b
 05r2XGgZB1dzZ2fm2shE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014 15:14:00 Dave Gerlach wrote:
> @@ -66,6 +66,11 @@ extern void ioport_unmap(void __iomem *);
>  #define ioremap_wc ioremap_nocache
>  #endif
>  
> +#ifndef ARCH_HAS_IOREMAP_EXEC
> +#define ioremap_exec ioremap
> +#define ioremap_exec_nocache ioremap_nocache
> +#endif
> +
>  #ifdef CONFIG_PCI
>  /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
>  struct pci_dev;
> 

ioremap and ioremap_nocache are the same, and there is no
architecture-independent interface to map an MMIO range as
cached because a lot of architectures can't do that.

Also, I think there are architectures that cannot execute
from uncached memory, so I think adding this as a generic
API is not a good idea.

	Arnd
