Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaI2UlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:41:05 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:49639 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI2UlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:41:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more standard place
Date: Mon, 29 Sep 2014 23:41:09 +0300
Message-ID: <3849580.CgKEmcV7as@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com> <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Thank you for the patch.

On Monday 29 September 2014 16:02:39 Boris Brezillon wrote:
> Rename mediabus formats and move the enum into a separate header file so
> that it can be used by DRM/KMS subsystem without any reference to the V4L2
> subsystem.
> 
> Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> definitions.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/uapi/linux/Kbuild             |   1 +
>  include/uapi/linux/v4l2-mediabus.h    | 183 +++++++++++++------------------
>  include/uapi/linux/video-bus-format.h | 127 +++++++++++++++++++++++
>  3 files changed, 207 insertions(+), 104 deletions(-)
>  create mode 100644 include/uapi/linux/video-bus-format.h

One of the self-inflicted rules in V4L2 is to properly document every new 
media bus format when adding it to the kernel. The documentation is located in 
Documentation/DocBook/media/v4l/subdev-formats.xml. If we move the formats to 
a centralized header (which I believe is a good idea), we should also update 
the documentation, and possibly its location. I really want to avoid getting 
undocumented formats merged, and this will happen if we don't make the rule 
clear and/or don't make the documentation easily accessible.

Incidentally, patch 2/5 in this series is missing a documentation update ;-)

-- 
Regards,

Laurent Pinchart

