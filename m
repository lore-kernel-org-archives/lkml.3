Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBKWBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:01:17 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56678 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaBKWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:01:15 -0500
Message-ID: <1392156072.14317.26.camel@x220>
Subject: Re: [PATCH 01/28] Remove CPU_MMP3
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Weinberger <richard@nod.at>, Felipe Balbi <balbi@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:USB PHY LAYER" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date: Tue, 11 Feb 2014 23:01:12 +0100
In-Reply-To: <20140211213054.GA2555@kroah.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-2-git-send-email-richard@nod.at>
	 <20140211213054.GA2555@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Feb 2014 22:01:13.0695 (UTC) FILETIME=[C7B066F0:01CF2774]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 13:30 -0800, Greg Kroah-Hartman wrote:
> On Sun, Feb 09, 2014 at 07:47:39PM +0100, Richard Weinberger wrote:
> > The symbol is an orphan, get rid of it.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > Acked-by: Paul Bolle <pebolle@tiscali.nl>
> > 
> > ---
> >  drivers/usb/phy/Kconfig      | 1 -
> >  drivers/video/mmp/Kconfig    | 2 +-
> >  drivers/video/mmp/hw/Kconfig | 2 +-
> >  3 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > index 7d1451d..b9b1c52 100644
> > --- a/drivers/usb/phy/Kconfig
> > +++ b/drivers/usb/phy/Kconfig
> > @@ -61,7 +61,6 @@ config KEYSTONE_USB_PHY
> >  
> >  config MV_U3D_PHY
> >  	bool "Marvell USB 3.0 PHY controller Driver"
> > -	depends on CPU_MMP3
> >  	select USB_PHY
> >  	help
> >  	  Enable this to support Marvell USB 3.0 phy controller for Marvell
> 
> Do this and the driver breaks the build so it needs to depend on
> something:
> 
> drivers/usb/phy/phy-mv-u3d-usb.c: In function ‘mv_u3d_phy_read’:
> drivers/usb/phy/phy-mv-u3d-usb.c:42:2: error: implicit declaration of function ‘writel_relaxed’ [-Werror=implicit-function-declaration]

This sort of proves that a driver that depends on an unknown Kconfig
symbol gets no build coverage (and will bit rot).

> Sorry, I can't take this as-is.

My mistake, I should have spotted this when looking a Richard's patch.

Some background (which I quickly dug up): config MV_U3D_PHY got added in
v3.7 through commit a67e76ac904c ("usb: phy: mv_u3d: Add usb phy driver
for mv_u3d"). It then depended on USB_MV_U3D. And that symbol depended
on CPU_MMP3 at that time. Ie, MV_U3D_PHY was unbuildable when it was
added.

In commit 60630c2eabd4 ("usb: gadget: mv_u3d: drop ARCH dependency")
MV_U3D_PHY was made depended directly on  CPU_MMP3. That kept it
unbuildable, of course.

Richard, assuming you agree with the above short history of MV_U3D_PHY,
would you mind sending a v2 that removes this unbuildable driver?


Paul Bolle

