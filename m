Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaKCLDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:03:36 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbaKCLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:03:32 -0500
Date: Mon, 3 Nov 2014 12:03:28 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20141103120328.3ac59c9d@bbrezillon>
In-Reply-To: <15186053.Jni2YnBHkN@avalon>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140930083952.GA4059@ulmo>
	<20140930114423.3a171aa9@bbrezillon>
	<15186053.Jni2YnBHkN@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, 01 Oct 2014 00:00:50 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,
> 
> On Tuesday 30 September 2014 11:44:23 Boris Brezillon wrote:
> > On Tue, 30 Sep 2014 10:39:53 +0200 Thierry Reding wrote:
> > > On Tue, Sep 30, 2014 at 09:37:57AM +0200, Boris Brezillon wrote:
> > >> On Mon, 29 Sep 2014 23:41:09 +0300 Laurent Pinchart wrote:
> > >
> > > [...]
> > > 
> > >>> Incidentally, patch 2/5 in this series is missing a documentation
> > >>> update ;-)
> > >>
> > >> Yep, regarding this patch, I wonder if it's really necessary to add
> > >> new formats to the v4l2_mbus_pixelcode enum.
> > >> If we want to move to this new common definition (across the video
> > >> related subsytems), we should deprecate the old enum
> > >> v4l2_mbus_pixelcode, and this start by not adding new formats, don't
> > >> you think ?
> > > 
> > > I agree in general, but I think it could prove problematic in practice.
> > > If somebody wants to use one of the new codes but is using the V4L2 enum
> > > they have a problem.
> > > 
> > > That said, given that there is now a unified enum people will hopefully
> > > start converting drivers to it instead.
> > 
> > I'm more worried about user-space lib/programs as this header is part
> > of the uapi...
> > 
> > But let's be optimistic here and keep porting new formats to
> > v4l2_mbus_pixelcode enum ;-).
> 
> I think we should try to keep the two in sync, until we can remove the 
> v4l2_mbus_pixelcode enum (I know, I'm being utopian here).
> 
> However, I really want all pixel codes to be properly documented, regardless 
> of whether we add them to v4l2_mbus_pixelcode or not.
> 
> > Anyway, I still don't know where to put the documentation. Dropping a
> > new video format doc without any context (I mean subdev-formats.xml is
> > included in media documentation, but there's no generic video doc yet)
> > is a bit weird...
> 
> Now that's a good question. We could start a generic video docbook 
> documentation. As I expect more infrastructure to be shared between V4L2 and 
> DRM (and, who knows, FBDEV...) over time, I think that would be a good move. 
> However docbook doesn't seem to be in the DRM developers' good books, so this 
> might be frown upon. We could also use a plain text, kerneldoc-like format for 
> the common documentation, but the formats would then disappear from the V4L2 
> documentation, which isn't a very good idea. For that reason I would favour 
> docbook.
> 
> I've CC'ed Hans Verkuil who might want to share his opinion on the matter.
> 

I started to write a video-formats.xml file (actually I copied the
subdev-formats.xml file and renamed v4l2-mbus into video-bus :-)), but
these files cannot be used without the proper video_api.tmpl file, and
I don't feel like I'm the one that should start writing this
documentation (or at least I'd need some help).

Anyway, even if you think I should write this doc, can we get this
series mainlined first so that my HLCDC driver can make it into 3.19 ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
