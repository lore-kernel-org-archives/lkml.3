Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaB0RWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:22:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60506 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaB0RWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:22:31 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 0/7] Move device tree graph parsing helpers to drivers/of
Date: Thu, 27 Feb 2014 18:35:33 +0100
Message-Id: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this version of the OF graph helper move series addresses a few of
Grant's and Tomi's comments.

Changes since v4:
 - Moved graph helpers into drivers/of/base.c
 - Fixed endpoint parsing patch to update users
 - Improved documentation, emphasizing features that differentiate
   the graph bindings from simple phandle graphs. Made it clear that
   this is not necessarily specific to data connections
 - Added cleanups to of_graph_get_next_endpoint routine
 - Added simplified binding for single port devices

regards
Philipp

Philipp Zabel (7):
  [media] of: move graph helpers from drivers/media/v4l2-core to
    drivers/of
  Documentation: of: Document graph bindings
  of: Warn if of_graph_get_next_endpoint is called with the root node
  of: Reduce indentation in of_graph_get_next_endpoint
  [media] of: move common endpoint parsing to drivers/of
  of: Implement simplified graph binding for single port devices
  of: Document simplified graph binding for single port devices

 Documentation/devicetree/bindings/graph.txt   | 137 +++++++++++++++++++++
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |  13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   5 +-
 drivers/media/v4l2-core/v4l2-of.c             | 133 +--------------------
 drivers/of/base.c                             | 165 ++++++++++++++++++++++++++
 include/linux/of_graph.h                      |  66 +++++++++++
 include/media/v4l2-of.h                       |  33 +-----
 13 files changed, 397 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/graph.txt
 create mode 100644 include/linux/of_graph.h

-- 
1.8.5.3

