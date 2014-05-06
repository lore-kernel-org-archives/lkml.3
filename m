Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbaEFL6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:58:00 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54843 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaEFL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:57:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Mathias Nyman <mathias.nyman@intel.com>, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Lior Amsalem <alior@marvell.com>, Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the Armada 38x
Date: Tue, 06 May 2014 13:57:44 +0200
Message-ID: <61061197.hLhKsFqJLF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1584794.IM1uiSkBdk@amdc1032>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com> <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com> <1584794.IM1uiSkBdk@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:avVxO3JDAVJVXZM23Pg69XiMnBZZ3MBqm4PDK5FiQqX
 XSBcx38Evj+uBS4rR8y++Se+DQydwVbL6RkWSLZ180s/ytytIG
 nR3AjxWKIZqxePyOC1/kXqh5ucE1A1dhUEPtX/mqF9S9oJ3615
 +8hXbqZ2SOEvp+i5wV33VsGfYj+F/+eSDDCT4nENRsFWecuQ4b
 +w9Kdb98IHe6YnhuSIeBtQ0RLsb4/d60nsCOfbHoRX9q/JmsTk
 RSHX5bwvpAvQ6qvsELNcdLv1RqKPLqnz2Coar4pbxCsSa5udsE
 zAGrixMniFGQPPQtbGTHukRsVHUDpbwvtw836B2ekwWx0ZleXG
 z18u5uYFclJ3HOEqNsxQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 13:34:46 Bartlomiej Zolnierkiewicz wrote:
> On Tuesday, May 06, 2014 02:14:01 AM Gregory CLEMENT wrote:
> > For the Armada 38x SoCs which come with an xhci controller, specific
> > initialization must be done during probe related to the MBus windows
> > configuration. This patch adds the support of this quirk.
> > 
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > ---
> >  drivers/usb/host/Kconfig      |  7 +++++
> >  drivers/usb/host/Makefile     |  1 +
> >  drivers/usb/host/xhci-mvebu.c | 71 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/usb/host/xhci-mvebu.h | 21 +++++++++++++
> >  drivers/usb/host/xhci-plat.c  |  6 ++++
> >  5 files changed, 106 insertions(+)
> >  create mode 100644 drivers/usb/host/xhci-mvebu.c
> >  create mode 100644 drivers/usb/host/xhci-mvebu.h
> > 
> > diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> > index 3d9e54062d62..e70943fac4a1 100644
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -29,6 +29,13 @@ if USB_XHCI_HCD
> >  config USB_XHCI_PLATFORM
> >       tristate
> >  
> > +config USB_XHCI_MVEBU
> > +     tristate "xHCI support for Marvell Armada 38x"
> 
> Please limit this driver to mvebu arch and compile testing, i.e.
> 
>         depends on ARCH_MVEBU || COMPILE_TEST

I think it actually needs a dependency on MVEBU_MBUS.

You probably need something like

	depends on MVEBU_MBUS=y || (MVEBU_MBUS=m && USB_XHCI=m)

Also, having the option 'tristate' makes no sense, since you
can't have it as a loadable module.

	Arnd
