Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbbAVIiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:38:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbAVIiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:38:11 -0500
Message-ID: <1421915886.3084.6.camel@pengutronix.de>
Subject: [GIT PULL] of: Add of-graph helpers to loop over endpoints and find
 ports by id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        kernel@pengutronix.de
Date: Thu, 22 Jan 2015 09:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I have prepared a tag with the of-graph helper patch series last
discussed here: https://lkml.org/lkml/2014/12/23/219

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux tags/of-graph-for-3.20

for you to fetch changes up to ae286de228412c3a60aa5b2707d53ead414028bb:

  of: Add of_graph_get_port_by_id function (2015-01-13 13:24:04 +0100)

regards
Philipp

----------------------------------------------------------------
of: Add of-graph helpers to loop over endpoints and find ports by id

This series converts of_graph_get_next_endpoint to decrement the refcount of
the passed prev parameter. This allows to add a for_each_endpoint_of_node
helper macro to loop over all endpoints in a device tree node.
The of_graph_get_port_by_id function is added to retrieve a port by its known
port id (contained in the reg property) from the device tree.

----------------------------------------------------------------
Philipp Zabel (3):
      of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
      of: Add for_each_endpoint_of_node helper macro
      of: Add of_graph_get_port_by_id function

 drivers/coresight/of_coresight.c                  | 13 ++-----
 drivers/gpu/drm/imx/imx-drm-core.c                | 13 ++-----
 drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 +++------
 drivers/media/platform/soc_camera/soc_camera.c    |  3 +-
 drivers/of/base.c                                 | 41 ++++++++++++++++++-----
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +---
 include/linux/of_graph.h                          | 18 ++++++++++
 7 files changed, 62 insertions(+), 48 deletions(-)

