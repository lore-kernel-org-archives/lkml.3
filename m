Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaCEXtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:49:13 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCEXtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:49:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Thu, 06 Mar 2014 00:50:39 +0100
Message-ID: <3099833.ZhlQFyxhbo@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140305171006.6243354a@samsung.com>
References: <1391958577.25424.22.camel@x220> <1600194.93iSF4Yz3E@avalon> <20140305171006.6243354a@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Thank you for the review.

On Wednesday 05 March 2014 17:10:06 Mauro Carvalho Chehab wrote:
> Em Tue, 11 Feb 2014 13:38:51 +0100 Laurent Pinchart escreveu:
> > On Tuesday 11 February 2014 12:17:01 Paul Bolle wrote:
> > > Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> > > camera interface - Build system") added a Kconfig entry for
> > > VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> > > 
> > > This entry was apparently copied from a similar entry for "OMAP 3
> > > Camera debug messages". The OMAP 3 entry is used to set the DEBUG
> > > compiler flag, which enables calls of dev_dbg().
> > > 
> > > So add a Makefile line to do that for omap4iss too.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > and applied to my tree.
> > 
> > > ---
> > > 0) v1 was called "[media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG". This
> > > versions implements Laurent's alternative (which is much better).
> > 
> > Thanks :-)
> > 
> > > 1) Still untested.
> > > 
> > >  drivers/staging/media/omap4iss/Makefile | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/staging/media/omap4iss/Makefile
> > > b/drivers/staging/media/omap4iss/Makefile index a716ce9..f46c6bd 100644
> > > --- a/drivers/staging/media/omap4iss/Makefile
> > > +++ b/drivers/staging/media/omap4iss/Makefile
> > > @@ -1,5 +1,7 @@
> > > 
> > >  # Makefile for OMAP4 ISS driver
> > > 
> > > +ccflags-$(CONFIG_VIDEO_OMAP4_DEBUG) += -DDEBUG
> > > +
> 
> This seems to be a very bad idea on my eyes. It is just creating an alias to
> an already existing Kconfig symbol with no good reason.
> 
> To be fair, there are also two other drivers doing this:
> 
> 	
drivers/media/platform/omap3isp/Makefile:ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG
> ) += -DDEBUG
> drivers/media/platform/ti-vpe/Makefile:ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG)
> += -DDEBUG
> 
> It sounds better do to a s/CONFIG_DEBUG/CONFIG_VIDEO_whatever_DEBUG/
> inside each of those driver, or to just remove this, and document that
> one should enable CONFIG_DEBUG if they want to debug v4l2 drivers.

Please note that -DDEBUG is equivalent to '#define DEBUG', not to '#define 
CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to have any effect. 
Furthermore, there's not CONFIG_DEBUG as far as I know.

An alternative to this would be to add

#ifdef CONFIG_VIDEO_OMAP3_DEBUG
#define DEBUG
#endif

at the beginning of each source file of the driver. That doesn't seem very 
practical to me though.

> > >  omap4-iss-objs += \
> > >  
> > >  	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o
> > > 
> > > iss_video.o

-- 
Regards,

Laurent Pinchart

