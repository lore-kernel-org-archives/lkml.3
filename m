Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaEMTtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:49:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60220 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaEMTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:48:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/8] usb: phy: fix isp1301-omap dependency on tps65010
Date: Tue, 13 May 2014 21:48:27 +0200
Message-ID: <7581425.j2FgrCi2P6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140513152631.GI1151@saruman.home>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de> <1399557141-1346645-5-git-send-email-arnd@arndb.de> <20140513152631.GI1151@saruman.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4r7luvxEpK5QKZwd68zyb0MnfK5L2OqCRnmxw6xLc0e
 0W17kqKLRGA/tBdybkw8Jk05pSfscYtjBr2rnrM78/nQn528Qu
 n9NFvPuFhohK2pW26cCDgKL14b+QoXiSaxvwAfm8nZIsXAELf2
 SC+xVkxpjs7g/6iwrP5RVTlU3TNpBvp/YBPaY0W9/eTcOBEkSR
 cMOStLj42eu1ze0izfeGAKAAfRrXEK5Vyx4WES3+BZnc/vEEiE
 5jp0KvR06EhmsLYhFboA6Gh7d1z5VOHLgxOlLpaEMMzSO/Xiuv
 6h+5KJL9a2VmGEtqnd1H/ZyEOjoCLx6cap1VlKeSUuIoUGnyEV
 gxHeUxRPmBpBWCGhU8YY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 10:26:31 Felipe Balbi wrote:
> On Thu, May 08, 2014 at 03:52:17PM +0200, Arnd Bergmann wrote:
> > The isp1301-omap driver cannot be built-in if the tps65010 driver
> > is a module, otherwise we get a link error from the reference to
> > the tps65010_set_vbus_draw function.
> > 
> > There is already a hack in the driver to work around the problem
> > of tps65010 being not available at all. This patch extends that
> > hack to ensure that the real tps65010_set_vbus_draw() function
> > is only called when it's avaiable.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-omap@vger.kernel.org
> > ---
> >  drivers/usb/phy/phy-isp1301-omap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
> > index 6e146d7..35a0dd2 100644
> > --- a/drivers/usb/phy/phy-isp1301-omap.c
> > +++ b/drivers/usb/phy/phy-isp1301-omap.c
> > @@ -94,7 +94,7 @@ struct isp1301 {
> >  
> >  #if defined(CONFIG_MACH_OMAP_H2) || defined(CONFIG_MACH_OMAP_H3)
> >  
> > -#if  defined(CONFIG_TPS65010) || defined(CONFIG_TPS65010_MODULE)
> > +#if  defined(CONFIG_TPS65010) || (defined(CONFIG_TPS65010_MODULE) && defined(MODULE))
> 
> nack, I would rather see a real fix, possibly also fixing the original
> hack.

Any suggestion how?

	Arnd
