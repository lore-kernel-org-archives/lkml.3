Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaKRSIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:08:36 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53885 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753946AbaKRSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:08:35 -0500
Date: Tue, 18 Nov 2014 20:07:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard
 CONFIG_VIDEO_V4L2_SUBDEV_API for v4l2_subdev_get_try_*()
Message-ID: <20141118180759.GT8907@valkosipuli.retiisi.org.uk>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
 <546B13CC.6050605@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B13CC.6050605@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans and Prabhakar,

On Tue, Nov 18, 2014 at 10:39:24AM +0100, Hans Verkuil wrote:
> On 11/17/14 11:41, Lad, Prabhakar wrote:
> > this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
> > for v4l2_subdev_get_try_*() functions.
> > In cases where a subdev using v4l2_subdev_get_try_*() calls
> > internally and the bridge using subdev pad ops which is
> > not MC aware forces to select MEDIA_CONTROLLER, as
> > VIDEO_V4L2_SUBDEV_API is dependent on it.
> > 
> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > ---
> >  include/media/v4l2-subdev.h | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 5860292..076ca11 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
> >  #define to_v4l2_subdev_fh(fh)	\
> >  	container_of(fh, struct v4l2_subdev_fh, vfh)
> >  
> > -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> >  #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
> >  	static inline struct rtype *					\
> >  	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> > @@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> > -#endif
> >  
> >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> >  
> > 
> 
> The problem is that v4l2_subdev_get_try_*() needs a v4l2_subdev_fh which
> you don't have if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. So I don't
> see how removing the guards help with that.
> 
> What can be done is that if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
> then these functions return NULL.

Sure. That's a better choice than removing the config option dependency of
the fields struct v4l2_subdev.

> BTW, one patch I will very happily accept is one where the __V4L2_SUBDEV_MK_GET_TRY
> is removed and these three try functions are just written as proper
> static inlines. I find it very obfuscated code.

I originally wrote them like that in order to avoid writing essentially the
same code three times over. If there will be more targets, the same repeats
further, should one write those functions open for all different macro
arguments. That's why it was a macro to begin with.

> In addition, because it is a macro you won't find the function definitions
> if you grep on the function name.

True as well. You could simply change the macro to include the full function
name. This was not suggested in review back then AFAIR.

> But any functional changes here need to be Acked by Laurent first.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
