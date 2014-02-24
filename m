Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBXAU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:20:27 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:46495 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbaBXAUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:20:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcDABWPClOl5H4JgWdsb2JhbABZwXODB4EjDgEBFiYogiUBAQQBOj8FCwsYCRUQDwFHBogQCMYjF45kB4Q4BKxKgVIo
From: Alistair Popple <alistair@popple.id.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/7] IBM Akebono: Add support to the OHCI platform driver for PPC476GTR
Date: Mon, 24 Feb 2014 11:20:21 +1100
Message-ID: <2060422.gLdTliUGah@mexican>
User-Agent: KMail/4.9.5 (Linux/3.5.0-45-generic; KDE/4.9.5; x86_64; ; )
In-Reply-To: <16991392.luyzl1NYP3@wuerfel>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-4-git-send-email-alistair@popple.id.au> <16991392.luyzl1NYP3@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 15:16:52 Arnd Bergmann wrote:
> On Friday 21 February 2014 17:31:29 Alistair Popple wrote:
> > +static const struct of_device_id ohci_of_match[] = {
> > +       { .compatible = "usb-ohci", },
> > +       {},
> > +};
> > +
> > 
> >  static const struct platform_device_id ohci_platform_table[] = {
> >  
> >         { "ohci-platform", 0 },
> >         { }
> > 
> > @@ -198,6 +209,7 @@ static struct platform_driver ohci_platform_driver = {
> > 
> >                 .owner  = THIS_MODULE,
> >                 .name   = "ohci-platform",
> >                 .pm     = &ohci_platform_pm_ops,
> > 
> > +               .of_match_table = ohci_of_match,
> > 
> >         }
> >  
> >  };
> 
> Linux-next already has a patch to add an of_match_table in this driver,
> using
> 
> static const struct of_device_id ohci_platform_ids[] = {
>         { .compatible = "generic-ohci", },
>         { }
> };
> 
> I think you should just use that string on your platform.

Excellent! I will drop this patch and use "generic-ohci" instead. Thanks for 
pointing this out.

- Alistair

> 	Arnd
