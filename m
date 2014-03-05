Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaCEUKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:10:16 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47556 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaCEUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:10:14 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-fa-531784a45b55
Date: Wed, 05 Mar 2014 17:10:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Message-id: <20140305171006.6243354a@samsung.com>
In-reply-to: <1600194.93iSF4Yz3E@avalon>
References: <1391958577.25424.22.camel@x220> <1409428.L7JLLEda5C@avalon>
 <1392117421.5686.4.camel@x220> <1600194.93iSF4Yz3E@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/hQN0lLeLBBjPe6ljsOfOL3aJ58Xo2
	i86JS9gtLu+aw2bRs2Erq8WiW2eYHdg87u07zOIxu2Mmq8f+uWvYPTZuf8Lk8XmTXABrFJdN
	SmpOZllqkb5dAlfGyzd/WAsOCFZ8XPGWpYFxEl8XIweHhICJxObe4i5GTiBTTOLCvfVsXYxc
	HEICSxgltnxdxAqSEBLoYZI4NT0KxGYRUJXo3HiKDcRmEzCSeNXYAlYjImAh0btoOiNIM7PA
	ekaJN8u3soMkhAXcJFb2zAKzeQUMJWZdOAhmcwpoSNzadYcdYlsro8SZ5XuZIM5wknj1ejIT
	RIOgxI/J91hAbGYBLYnN25pYIWx5ic1r3jJPYBSYhaRsFpKyWUjKFjAyr2IULS1OLihOSs81
	1CtOzC0uzUvXS87P3cQICe6iHYzPNlgdYhTgYFTi4d3gJx4sxJpYVlyZe4hRgoNZSYQ3IBIo
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgdG/eZWxJefSiP9T15/Im6Uhe/JZ3fJTWvl8e0/0S0g2
	vJy5btd+5n9V+m6HvJ/Xn3/r55+T1z99+uMfcR948jS32Pk173su3yQalrT9x3dWQ42cq07J
	G7YvfLNY7nt2pq30M3fLv5aFTr2fjgilbZHdrn04Q/Zk76Oih5/876mrPm4NfiXtYKfEUpyR
	aKjFXFScCABkutqnTAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 11 Feb 2014 13:38:51 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Paul,
> 
> Thank you for the patch.
> 
> On Tuesday 11 February 2014 12:17:01 Paul Bolle wrote:
> > Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> > camera interface - Build system") added a Kconfig entry for
> > VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> > 
> > This entry was apparently copied from a similar entry for "OMAP 3
> > Camera debug messages". The OMAP 3 entry is used to set the DEBUG
> > compiler flag, which enables calls of dev_dbg().
> > 
> > So add a Makefile line to do that for omap4iss too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> and applied to my tree.
> 
> > ---
> > 0) v1 was called "[media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG". This
> > versions implements Laurent's alternative (which is much better).
> 
> Thanks :-)
> 
> > 1) Still untested.
> > 
> >  drivers/staging/media/omap4iss/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/staging/media/omap4iss/Makefile
> > b/drivers/staging/media/omap4iss/Makefile index a716ce9..f46c6bd 100644
> > --- a/drivers/staging/media/omap4iss/Makefile
> > +++ b/drivers/staging/media/omap4iss/Makefile
> > @@ -1,5 +1,7 @@
> >  # Makefile for OMAP4 ISS driver
> > 
> > +ccflags-$(CONFIG_VIDEO_OMAP4_DEBUG) += -DDEBUG
> > +

This seems to be a very bad idea on my eyes. It is just creating an
alias to an already existing Kconfig symbol with no good reason.

To be fair, there are also two other drivers doing this:

	drivers/media/platform/omap3isp/Makefile:ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG) += -DDEBUG
	drivers/media/platform/ti-vpe/Makefile:ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG

It sounds better do to a s/CONFIG_DEBUG/CONFIG_VIDEO_whatever_DEBUG/ 
inside each of those driver, or to just remove this, and document that
one should enable CONFIG_DEBUG if they want to debug v4l2 drivers.

> >  omap4-iss-objs += \
> >  	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o
> > iss_video.o
> 


-- 

Cheers,
Mauro
