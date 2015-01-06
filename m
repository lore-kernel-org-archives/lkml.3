Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbbAFLI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:08:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42682 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752973AbbAFLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:08:56 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [RESEND PATCH v5 0/3] drm: describe display bus format
Date: Tue,  6 Jan 2015 12:08:42 +0100
Message-Id: <1420542525-13507-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Resending this series I depends on for the Atmel HLCDC driver which, BTW,
I really expect to be merged in 3.20.
Thierry, do you see any remaining issues that should be fixed ?
If not, Dave, Thierry, could you take it for 3.20 (or, if you prefer, I
could make it part of my PR for the atmel-hlcdc driver inclusion).

Here follows the usual description:

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

Changes since v4:
 - fix typo
 - fix 'line over 80 characters' warnings
 - fix leak of formats array

Changes since v3:
 - store num_bus_formats on an unsigned int
 - clearly state that fmts argument (in drm_display_info_set_bus_formats
   function) should be an array of MEDIA_BUS_FMT_* values.

Changes since v2:
 - use the MEDIA_BUS_FMT macros

Changes since v1:
 - rename nformats into num_formats
 - declare num_formats as an unsigned int


Boris Brezillon (3):
  drm: add bus_formats and num_bus_formats fields to drm_display_info
  drm: panel: simple-panel: add support for bus_format retrieval
  drm: panel: simple-panel: add bus format information for foxlink panel

 drivers/gpu/drm/drm_crtc.c           | 35 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/panel/panel-simple.c |  6 ++++++
 include/drm/drm_crtc.h               |  8 ++++++++
 3 files changed, 49 insertions(+)

-- 
1.9.1

