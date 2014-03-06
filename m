Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaCFRNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:13:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49293 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:13:40 -0500
Message-ID: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
Subject: [GIT PULL] Move device tree graph parsing helpers to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Thu, 06 Mar 2014 18:13:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro, Russell,

I have temporarily removed the simplified bindings at Sylwester's
request and updated the branch with the acks. The following changes
since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git topic/of-graph

for you to fetch changes up to d484700a36952c6675aa47dec4d7a536929aa922:

  of: Warn if of_graph_parse_endpoint is called with the root node (2014-03-06 17:41:54 +0100)

----------------------------------------------------------------
Philipp Zabel (6):
      [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
      Documentation: of: Document graph bindings
      of: Warn if of_graph_get_next_endpoint is called with the root node
      of: Reduce indentation in of_graph_get_next_endpoint
      [media] of: move common endpoint parsing to drivers/of
      of: Warn if of_graph_parse_endpoint is called with the root node

 Documentation/devicetree/bindings/graph.txt   | 129 ++++++++++++++++++++++
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |  13 ++-
 drivers/media/platform/exynos4-is/mipi-csis.c |   5 +-
 drivers/media/v4l2-core/v4l2-of.c             | 133 +----------------------
 drivers/of/base.c                             | 151 ++++++++++++++++++++++++++
 include/linux/of_graph.h                      |  66 +++++++++++
 include/media/v4l2-of.h                       |  33 +-----
 13 files changed, 375 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/graph.txt
 create mode 100644 include/linux/of_graph.h


