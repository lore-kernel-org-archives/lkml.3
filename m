Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaKGPbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:31:48 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60065 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbaKGPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:31:46 -0500
Date: Fri, 7 Nov 2014 16:31:41 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Message-ID: <20141107163141.3866f3c4@bbrezillon>
In-Reply-To: <545CDB8D.4080406@xs4all.nl>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415369269-5064-11-git-send-email-boris.brezillon@free-electrons.com>
	<545CDB8D.4080406@xs4all.nl>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 15:47:41 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Nitpicks:
> 
> On 11/07/14 15:07, Boris Brezillon wrote:
> > Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> > users don't have access to these definitions.
> > 
> > We have to keep this definition for user-space users even though they're
> > encouraged to move to the new media_bus_format enum.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  include/uapi/linux/v4l2-mediabus.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index 3d87db7..4f31d0e 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -15,6 +15,14 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/media-bus-format.h>
> >  
> > +#ifndef __KERNEL__
> > +
> > +/*
> > + * enum v4l2_mbus_pixelcode and its defintions are now deprecated, and
> 
> defintions -> definitions
> 
> > + * MEDIA_BUS_FMT_ defintions (defined in media-bus-format.h) should be
> 
> and again...
> 
> > + * used instead.
> 
> I would also add something like this:
> 
> "New defines should only be added to media-bus-format.h. The v4l2_mbus_pixelcode
> enum is frozen."

I'll fix those typos and add this sentence.

> 
> > + */
> > +
> >  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
> >  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
> >  
> > @@ -102,6 +110,7 @@ enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
> >  };
> > +#endif /* __KERNEL__ */
> >  
> >  /**
> >   * struct v4l2_mbus_framefmt - frame format on the media bus
> > 
> 
> Can you move this struct forward to before the v4l2_mbus_pixelcode enum? That way
> the obsolete code is at the end of the header. People might miss this struct
> otherwise.

Sure.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
