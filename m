Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaKRNq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:46:27 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754059AbaKRNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:46:25 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/3] drm: describe display bus format
Date: Tue, 18 Nov 2014 14:46:17 +0100
Message-Id: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series makes use of the MEDIA_BUS_FMT definition to describe how
the data are transmitted to the display.

This will allow drivers to configure their output display bus according
to the display capabilities.
For example some display controllers support DPI (or raw RGB) connectors
and need to specify which format will be transmitted on the DPI bus
(RGB444, RGB565, RGB888, ...).

This series also adds a field to the panel_desc struct so that one
can specify which format is natevely supported by a panel.

Regards,

Boris

Changes since v2:
 - use the MEDIA_BUS_FMT macros

Changes since v1:
 - rename nformats into num_formats
 - declare num_formats as an unsigned int

Boris Brezillon (3):
  drm: add bus_formats and nbus_formats fields to drm_display_info
  drm: panel: simple-panel: add support for bus_format retrieval
  drm: panel: simple-panel: add bus format information for foxlink panel

 drivers/gpu/drm/drm_crtc.c           | 30 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/panel/panel-simple.c |  6 ++++++
 include/drm/drm_crtc.h               |  7 +++++++
 3 files changed, 43 insertions(+)

-- 
1.9.1

