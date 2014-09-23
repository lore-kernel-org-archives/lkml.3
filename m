Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbaIWQJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:09:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59570 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756380AbaIWQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:09:27 -0400
Date: Tue, 23 Sep 2014 18:09:23 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20140923180923.287758a7@bbrezillon>
In-Reply-To: <Pine.LNX.4.64.1409231426220.17074@axis700.grange>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
	<1406031827-12432-2-git-send-email-boris.brezillon@free-electrons.com>
	<Pine.LNX.4.64.1409231426220.17074@axis700.grange>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Tue, 23 Sep 2014 14:33:20 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Boris,
> 
> On Tue, 22 Jul 2014, Boris BREZILLON wrote:
> 
> > Rename mediabus formats and move the enum into a separate header file so
> > that it can be used by DRM/KMS subsystem without any reference to the V4L2
> > subsystem.
> > 
> > Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> > definitions.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> In principle I find this a good idea, certainly it's good to reuse code. 
> Just wondering, wouldn't it be better instead of adding those defines to 
> define a macro like
> 
> #define VIDEO_BUS_TO_MBUS(x)	V4L2_MBUS_ ## x = VIDEO_BUS_ ## x
> 
> and then do
> 
> enum v4l2_mbus_pixelcode {
> 	VIDEO_BUS_TO_MBUS(FIXED),
> 	VIDEO_BUS_TO_MBUS(RGB444_2X8_PADHI_BE),
> 	...
> };
> 
> ? I'm not very strong on this, I just think an enum is nicer than a bunch 
> of defines and this way copy-paste errors are less likely, but if you or 
> others strongly disagree - I won't insist :)

I'd say it might be a good solution if we enforce new users (including
user space users) to use video_bus_format enum values instead of
v4l2_mbus_pixelcode ones. But if we keep adding new values to this enum
I'd say this approach is less readable than having the full names
(V4L2_MBUS_XXX) expressed, because users will still have to use those
full names.

Anyway, I can still replace this macro list by an enum:

enum v4l2_mbus_pixelcode {
	V4L2_MBUS_FIXED = VIDEO_BUS_FIXED,
	V4L2_MBUS_RGB444_2X8_PADHI_BE = VIDEO_BUS_RGB444_2X8_PADHI_BE,
	...
};

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
