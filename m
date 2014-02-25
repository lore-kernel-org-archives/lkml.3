Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBYO6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:58:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaBYO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:58:45 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 0/3] Move device tree graph parsing helpers to drivers/of
Date: Tue, 25 Feb 2014 15:58:21 +0100
Message-Id: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this version moves the graph helpers to drivers/of again instead of
drivers/media. Since the location changed again, I have dropped the
Acks. A second patch is added that splits out the common parts from
v4l2_of_parse_endpoint into of_graph_parse_endpoint and I have added
a binding description Documentation/devicetree/bindings/graph.txt.

Changes since v3:
 - Moved back to drivers/of
 - Added DT binding documentation

regards
Philipp

Philipp Zabel (3):
  [media] of: move graph helpers from drivers/media/v4l2-core to
    drivers/of
  [media] of: move common endpoint parsing to drivers/of
  Documentation: of: Document graph bindings

 Documentation/devicetree/bindings/graph.txt   |  98 +++++++++++++++
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |   3 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   3 +-
 drivers/media/v4l2-core/v4l2-of.c             | 133 +--------------------
 drivers/of/Makefile                           |   1 +
 drivers/of/of_graph.c                         | 166 ++++++++++++++++++++++++++
 include/linux/of_graph.h                      |  66 ++++++++++
 include/media/v4l2-of.h                       |  34 +-----
 14 files changed, 355 insertions(+), 172 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/graph.txt
 create mode 100644 drivers/of/of_graph.c
 create mode 100644 include/linux/of_graph.h

-- 
1.8.5.3

