Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaI3HiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:38:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52845 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbaI3HiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:38:01 -0400
Date: Tue, 30 Sep 2014 09:37:57 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20140930093757.003741ac@bbrezillon>
In-Reply-To: <3849580.CgKEmcV7as@avalon>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
	<3849580.CgKEmcV7as@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 23:41:09 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,
> 
> Thank you for the patch.
> 
> On Monday 29 September 2014 16:02:39 Boris Brezillon wrote:
> > Rename mediabus formats and move the enum into a separate header file so
> > that it can be used by DRM/KMS subsystem without any reference to the V4L2
> > subsystem.
> > 
> > Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> > definitions.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  include/uapi/linux/Kbuild             |   1 +
> >  include/uapi/linux/v4l2-mediabus.h    | 183 +++++++++++++------------------
> >  include/uapi/linux/video-bus-format.h | 127 +++++++++++++++++++++++
> >  3 files changed, 207 insertions(+), 104 deletions(-)
> >  create mode 100644 include/uapi/linux/video-bus-format.h
> 
> One of the self-inflicted rules in V4L2 is to properly document every new 
> media bus format when adding it to the kernel. The documentation is located in 
> Documentation/DocBook/media/v4l/subdev-formats.xml. If we move the formats to 
> a centralized header (which I believe is a good idea), we should also update 
> the documentation, and possibly its location. I really want to avoid getting 
> undocumented formats merged, and this will happen if we don't make the rule 
> clear and/or don't make the documentation easily accessible.

Any idea where this new documentation should go
(Documentation/DocBook/video/video-bus-formats.xml) ?

> 
> Incidentally, patch 2/5 in this series is missing a documentation update ;-)

Yep, regarding this patch, I wonder if it's really necessary to add
new formats to the v4l2_mbus_pixelcode enum.
If we want to move to this new common definition (across the video
related subsytems), we should deprecate the old enum
v4l2_mbus_pixelcode, and this start by not adding new formats, don't
you think ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
