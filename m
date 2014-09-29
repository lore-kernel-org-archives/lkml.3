Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaI2ODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:03:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47328 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaI2ODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:03:41 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/5] video: describe data bus formats
Date: Mon, 29 Sep 2014 16:02:38 +0200
Message-Id: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is a proposal to describe the different data formats used
by HW components to connect with each other.

This is just a copy of the existing V4L2_MBUS_FMT defintions with a neutral
name so that it can be used by V4L2 and DRM/KMS subsystem.

This series also makes use of this video_bus_format enum in the DRM/KMS
subsystem to define the data fomats supported on the connector <-> device
link.

Best Regards,

Boris

Changes since v1:
 - define an enum and use a macro for v4l2 bus formats definitions
 - rename nformats into num_formats
 - declare num_formats as an unsigned int

Boris BREZILLON (3):
  drm: add bus_formats and nbus_formats fields to drm_display_info
  drm: panel: simple-panel: add support for bus_format retrieval
  drm: panel: simple-panel: add bus format information for foxlink panel

Boris Brezillon (2):
  video: move mediabus format definition to a more standard place
  video: add RGB444_1X12 and RGB565_1X16 bus formats

 drivers/gpu/drm/drm_crtc.c            |  31 ++++++
 drivers/gpu/drm/panel/panel-simple.c  |   6 ++
 include/drm/drm_crtc.h                |   8 ++
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/v4l2-mediabus.h    | 185 +++++++++++++++-------------------
 include/uapi/linux/video-bus-format.h | 129 ++++++++++++++++++++++++
 6 files changed, 256 insertions(+), 104 deletions(-)
 create mode 100644 include/uapi/linux/video-bus-format.h

-- 
1.9.1

