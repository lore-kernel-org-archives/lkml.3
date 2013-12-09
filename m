Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab3LIRkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:40:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64990 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760804Ab3LIRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:40:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX191XX2bkZ+yBwzLSvSJR1RN
Date: Mon, 9 Dec 2013 09:40:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm: omap: remove *.auto* from device names given
 in usb_bind_phy
Message-ID: <20131209174000.GA12527@atomide.com>
References: <1386331571-30903-1-git-send-email-kishon@ti.com>
 <1386331571-30903-3-git-send-email-kishon@ti.com>
 <CABxcv=n67gNq6ayx+t_mfZ0++UBKkXpH9avXvRKFEH4VUrwy0g@mail.gmail.com>
 <20131206210835.GM21086@saruman.home>
 <52A55E2C.7070500@ti.com>
 <CABxcv=kYAB5MKtW0O1RLZUXPxiTmoSDD0nuHB=Bjy2gy+wzvhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABxcv=kYAB5MKtW0O1RLZUXPxiTmoSDD0nuHB=Bjy2gy+wzvhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier@dowhile0.org> [131209 03:51]:
> Hi Kishon,
> 
> On Mon, Dec 9, 2013 at 7:07 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> > Hi,
> >
> >
> > On Saturday 07 December 2013 02:38 AM, Felipe Balbi wrote:
> >>
> >> Hi,
> >>
> >> On Fri, Dec 06, 2013 at 01:14:38PM +0100, Javier Martinez Canillas wrote:
> >>>
> >>> On Fri, Dec 6, 2013 at 1:06 PM, Kishon Vijay Abraham I <kishon@ti.com>
> >>> wrote:
> >>>>
> >>>> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while
> >>>> creating
> >>>> MUSB core device. So in usb_bind_phy (binds the controller with the
> >>>> PHY), the
> >>>> device name of the controller had *.auto* in it. Since with using
> >>>> PLATFORM_DEVID_AUTO, there is no way to know the exact device name in
> >>>> advance,
> >>>> the data given in usb_bind_phy became obsolete and usb_get_phy was
> >>>> failing.
> >>>> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO.
> >>>> Corresponding
> >>>> change is done in board file here.
> >>>>
> >>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>> ---
> >>>>   arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
> >>>>   arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
> >>>>   arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
> >>>>   arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
> >>>>   arch/arm/mach-omap2/board-ldp.c            |    2 +-
> >>>>   arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
> >>>>   arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
> >>>>   arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
> >>>>   arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
> >>>>   arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
> >>>>   arch/arm/mach-omap2/board-overo.c          |    2 +-
> >>>>   arch/arm/mach-omap2/board-rx51.c           |    2 +-
> >>>>   12 files changed, 12 insertions(+), 12 deletions(-)
> >>>>
> >>>
> >>> You can drop this patch since boards files are being removed for v3.14
> >>
> >>
> >> if we can drop this patch, the whole series is invalid, since we'll be
> >> using DT phandles to find PHYs going forward, no ?
> >>
> > yeah. But in one of the other threads, Tony seemed ok to take a patch that
> > fixes the same issue in mach-omap2/twl-common.c. So it's better to confirm
> > with Tony.
> >
> 
> Yes, I just read the other thread ("[PATCH] omap: twl-common: Fix
> musb-hdrc device name") and I see that these patches are fixing a
> v3.13 regression and are meant for the -rc cycle and not for v3.14.

Sorry guys, I'm a bit lost with these USB regression fixes.
Which regression fix do we need for v3.13-rc series?

If there's an option, I'd rather not touch all the board-*.c files as
those are about to get dropped for v3.14.

Regards,

Tony
