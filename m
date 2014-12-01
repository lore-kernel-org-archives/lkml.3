Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaLAIWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:22:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49338 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbaLAIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:21:09 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 0/3] drm: describe display bus format
Date: Mon,  1 Dec 2014 09:20:58 +0100
Message-Id: <1417422061-10384-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
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

 drivers/gpu/drm/drm_crtc.c           | 32 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/panel/panel-simple.c |  6 ++++++
 include/drm/drm_crtc.h               |  7 +++++++
 3 files changed, 45 insertions(+)

-- 
1.9.1

