Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaK3VQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:16:19 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:58368 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaK3VQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:16:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API for v4l2_subdev_get_try_*()
Date: Sun, 30 Nov 2014 23:16:48 +0200
Message-ID: <1680188.7K1XCBdsCk@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CA+V-a8tNW8JXKEeaAwEKkB+SCS2_My228spsgpbb5JQPjdC2Og@mail.gmail.com>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com> <3017627.SLutb67dz2@avalon> <CA+V-a8tNW8JXKEeaAwEKkB+SCS2_My228spsgpbb5JQPjdC2Og@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2014 21:05:50 Prabhakar Lad wrote:
> On Sat, Nov 29, 2014 at 7:12 PM, Laurent Pinchart wrote:
> > Hi Prabhakar,
> 
> [Snip]
> 
> >> > Sure. That's a better choice than removing the config option dependency
> >> > of the fields struct v4l2_subdev.
> > 
> > Decoupling CONFIG_VIDEO_V4L2_SUBDEV_API from the availability of the
> > in-kernel pad format and selection rectangles helpers is definitely a
> > good idea. I was thinking about decoupling the try format and rectangles
> > from v4l2_subdev_fh by creating a kind of configuration store structure
> > to store them, and embedding that structure in v4l2_subdev_fh. The
> > pad-level operations would then take a pointer to the configuration store
> > instead of the v4l2_subdev_fh. Bridge drivers that want to implement
> > TRY_FMT based on pad-level operations would create a configuration store,
> > use the pad-level operations, and destroy the configuration store. The
> > userspace subdev API would use the configuration store from the file
> > handle.
> 
> are planning to work/post any time soon ? Or are you OK with suggestion from
> Hans ?

I have no plan to work on that myself now, I was hoping you could implement it 
;-)

-- 
Regards,

Laurent Pinchart

