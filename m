Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3IJMCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:02:18 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56614 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJMCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:02:17 -0400
Date: Tue, 10 Sep 2013 14:02:07 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] arm: add early_ioremap support
Message-ID: <20130910120205.GW18151@rocoto.smurfnet.nu>
References: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org>
 <1378459158-2145-3-git-send-email-leif.lindholm@linaro.org>
 <20130906161448.GI1946@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906161448.GI1946@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:14:49PM +0100, Catalin Marinas wrote:
> On Fri, Sep 06, 2013 at 10:19:18AM +0100, Leif Lindholm wrote:
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -877,6 +878,10 @@ void __init setup_arch(char **cmdline_p)
> > 
> >         parse_early_param();
> > 
> > +#ifdef CONFIG_EARLY_IOREMAP
> > +       early_ioremap_init();
> > +#endif
> 
> Better with a dummy early_ioremap_init() in the header when
> !CONFIG_EARLY_IOREMAP to avoid the #ifdef here.
 
Ok, makes sense.

> > --- /dev/null
> > +++ b/arch/arm/mm/early_ioremap.c
> > @@ -0,0 +1,271 @@
> > +/*
> > + * early_ioremap() support for ARM
> > + *
> > + * Based on existing support in arch/x86/mm/ioremap.c
> 
> At a very quick look, this looks really close to the x86 implementation.
> Any reason why this cannot be made generic and avoid duplication?

Mainly that the bits that can be easily shared aren't really the
interesting ones. Making it properly shared would require a rewrite
of ARM kmap().

/
    Leif
