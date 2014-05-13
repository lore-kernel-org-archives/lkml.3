Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaEMTjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:39:53 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56809 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaEMTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:39:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, balbi@ti.com
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] usb: xhci: avoid warning for !PM_SLEEP
Date: Tue, 13 May 2014 21:39:37 +0200
Message-ID: <7882044.S9pqnTAVYy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140513152829.GK1151@saruman.home>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de> <1399557141-1346645-7-git-send-email-arnd@arndb.de> <20140513152829.GK1151@saruman.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7XMiPeWR1SvIV7It6JjBzNyupSoPoBJCAAKWHoyJFKz
 fDb6A6vzSPOcFkcZ6czGDv/pginB4AonKU5KX1s4mba3GlJOqp
 BEGI5GP37AYUtAlTBhjK72NuKsxBSZAdv2K3wciHp73WqqcJP5
 0oFo4r6DEb50Luad3lL3s7gHSY+z5J6nTr6ao2x9Oea9qsyr8b
 wAlVDqR0GaZoNRb9jI6px3T3Lwghx7UKEk5QvwIrf19Khr8LjD
 Q6WjEHBHqgybxCQDkyWW3BGyIMaLaHeHB3IKb0fQjnyzjWLznG
 NLySTkxAKOHtzNXzaFiEP99BD1GnxbPVfHukCW3DLUmh2hkpbC
 aWefy6SVygH58oqygR8g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 10:28:29 Felipe Balbi wrote:
> > diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> > index 151901c..3473296 100644
> > --- a/drivers/usb/host/xhci-plat.c
> > +++ b/drivers/usb/host/xhci-plat.c
> > @@ -202,7 +202,7 @@ static int xhci_plat_remove(struct platform_device *dev)
> >       return 0;
> >  }
> >  
> > -#ifdef CONFIG_PM
> > +#ifdef CONFIG_PM_SLEEP
> 
> can we just drop the ifdeferry altogether, including from SET_*_OPS
> macros ? This is just ridiculous that every merge window we have tens of
> patches fixing the ifdef in several drivers.

That would work for me. Another suggestion that came up before was
to change the SET_*_OPS so that the compiler silently drops the unused
functions, but unfortunately that would require changing all drivers.

	Arnd
