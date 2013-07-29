Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3G2TDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:03:03 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58420 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3G2TDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:03:00 -0400
Subject: Re: [PATCH v2 1/6] usb: phy: msm: Move mach depndend code to
 platform data
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20130729122344.GH24801@radagast>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
	 <1375081464-14206-2-git-send-email-iivanov@mm-sol.com>
	 <20130729122344.GH24801@radagast>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Jul 2013 22:02:58 +0300
Message-ID: <1375124578.5444.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> > Cc: Bryan Huntsman <bryanh@codeaurora.org>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-usb@vger.kernel.org
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
> >  arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++
> 
> I need acks for these.
> 
> >  drivers/usb/phy/phy-msm-usb.c     |   55 ++++++++++---------------------------
> >  include/linux/usb/msm_hsusb.h     |    3 ++
> >  4 files changed, 87 insertions(+), 41 deletions(-)
> > 
> > diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
> > index db3d8c0..6b35953 100644
> > --- a/arch/arm/mach-msm/board-msm7x30.c
> > +++ b/arch/arm/mach-msm/board-msm7x30.c
> > @@ -31,6 +31,7 @@
> >  #include <asm/setup.h>
> >  
> >  #include <mach/board.h>
> > +#include <mach/clk.h>
> >  #include <mach/msm_iomap.h>
> >  #include <mach/dma.h>
> >  
> > @@ -61,10 +62,44 @@ static int hsusb_phy_init_seq[] = {
> >  	-1
> >  };
> >  
> > +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
> 
> looks like you should be using the reset controller framework ?
> (drivers/reset)

Probably, but there still nothing in place in the msm,
which provide this functionality. I am looking it to
right now.

Regards,
Ivan



