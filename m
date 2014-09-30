Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaI3VAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:00:55 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50765 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaI3VAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:00:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more standard place
Date: Wed, 01 Oct 2014 00:00:50 +0300
Message-ID: <15186053.Jni2YnBHkN@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140930114423.3a171aa9@bbrezillon>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com> <20140930083952.GA4059@ulmo> <20140930114423.3a171aa9@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Tuesday 30 September 2014 11:44:23 Boris Brezillon wrote:
> On Tue, 30 Sep 2014 10:39:53 +0200 Thierry Reding wrote:
> > On Tue, Sep 30, 2014 at 09:37:57AM +0200, Boris Brezillon wrote:
> >> On Mon, 29 Sep 2014 23:41:09 +0300 Laurent Pinchart wrote:
> >
> > [...]
> > 
> >>> Incidentally, patch 2/5 in this series is missing a documentation
> >>> update ;-)
> >>
> >> Yep, regarding this patch, I wonder if it's really necessary to add
> >> new formats to the v4l2_mbus_pixelcode enum.
> >> If we want to move to this new common definition (across the video
> >> related subsytems), we should deprecate the old enum
> >> v4l2_mbus_pixelcode, and this start by not adding new formats, don't
> >> you think ?
> > 
> > I agree in general, but I think it could prove problematic in practice.
> > If somebody wants to use one of the new codes but is using the V4L2 enum
> > they have a problem.
> > 
> > That said, given that there is now a unified enum people will hopefully
> > start converting drivers to it instead.
> 
> I'm more worried about user-space lib/programs as this header is part
> of the uapi...
> 
> But let's be optimistic here and keep porting new formats to
> v4l2_mbus_pixelcode enum ;-).

I think we should try to keep the two in sync, until we can remove the 
v4l2_mbus_pixelcode enum (I know, I'm being utopian here).

However, I really want all pixel codes to be properly documented, regardless 
of whether we add them to v4l2_mbus_pixelcode or not.

> Anyway, I still don't know where to put the documentation. Dropping a
> new video format doc without any context (I mean subdev-formats.xml is
> included in media documentation, but there's no generic video doc yet)
> is a bit weird...

Now that's a good question. We could start a generic video docbook 
documentation. As I expect more infrastructure to be shared between V4L2 and 
DRM (and, who knows, FBDEV...) over time, I think that would be a good move. 
However docbook doesn't seem to be in the DRM developers' good books, so this 
might be frown upon. We could also use a plain text, kerneldoc-like format for 
the common documentation, but the formats would then disappear from the V4L2 
documentation, which isn't a very good idea. For that reason I would favour 
docbook.

I've CC'ed Hans Verkuil who might want to share his opinion on the matter.

-- 
Regards,

Laurent Pinchart

