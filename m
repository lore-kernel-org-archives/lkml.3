Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaJBR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:26:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64758 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaJBR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:26:14 -0400
Message-ID: <1412270771.20184.1.camel@lolumad>
Subject: Re: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
From: Rostislav Lisovy <lisovy@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "luca.ellero@brickedbrain.com" <luca.ellero@brickedbrain.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Date: Thu, 02 Oct 2014 19:26:11 +0200
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825FCE627@P3PWEX4MB008.ex4.secureserver.net>
References: <542D640E.6010200@gmail.com>
	 <DC148C5AA1CEBA4E87973D432B1C2D8825FCE627@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 17:01 +0000, Hartley Sweeten wrote:
> On Thursday, October 02, 2014 7:41 AM, Chen Gang wrote:
> > COMEDI_II_PCI20KC needs HAS_IOMEM, so depend on it. The related error (
> > with allmodconfig under um):
> >
> >     CC [M]  drivers/staging/comedi/drivers/ii_pci20kc.o
> >   drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_attach’:
> >   drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
> >     dev->mmio = ioremap(membase, II20K_SIZE);
> >     ^
> >   drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment makes pointer from integer without a cast [enabled by default]
> >     dev->mmio = ioremap(membase, II20K_SIZE);
> >               ^
> >   drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_detach’:
> >   drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
> >      iounmap(dev->mmio);
> >      ^
> >
> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> > ---
> >  drivers/staging/comedi/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> > index a8bc2b5..b709736 100644
> > --- a/drivers/staging/comedi/Kconfig
> > +++ b/drivers/staging/comedi/Kconfig
> > @@ -426,6 +426,7 @@ config COMEDI_AIO_IIRO_16
> >  
> >  config COMEDI_II_PCI20KC
> >  	tristate "Intelligent Instruments PCI-20001C carrier support"
> > +	depends on HAS_IOMEM
> >  	---help---
> >  	  Enable support for Intelligent Instruments PCI-20001C carrier
> >  	  PCI-20001, PCI-20006 and PCI-20341
> 
> This seems appropriate.
> 
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 

Since "egrep -irn "ioremap" drivers/staging/comedi/drivers | wc -l"
shows "39" does it mean that this should be added to all the other
drivers as well?

Rostislav Lisovy

