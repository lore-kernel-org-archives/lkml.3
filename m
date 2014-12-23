Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaLWNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:09:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaLWNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:09:25 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
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
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v7 0/3] Add of-graph helpers to loop over endpoints and find ports by id
Date: Tue, 23 Dec 2014 14:09:15 +0100
Message-Id: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I addressed Andrzej's comments on of_graph_get_port_by_id() and added
Mathieu's ack to the first patch. Also I missed the omap2-dss init code
last time around. For the first patch, I'd like to get an ack for the rcar-du
and omap2-dss changes so this can go in through Grant's tree.

This series converts all existing users of of_graph_get_next_endpoint that pass
a non-NULL prev argument to the function and decrement its refcount themselves
to stop doing that. The of_node_put is moved into of_graph_get_next_endpoint
instead.
This allows to add a for_each_endpoint_of_node helper macro to loop over all
endpoints in a device tree node.

Changes since v6:
 - Fixed of_graph_get_port_by_id to handle the optional 'ports' node
   and synchronize documentation and parameter names in the process.
 - Added omap2-dss to the list of updated of_graph_get_next_endpoint
   users in the first patch.
 - Added Mathieu's ack to the first patch.

The previous version can be found here: https://lkml.org/lkml/2014/12/22/220

regards
Philipp

Philipp Zabel (3):
  of: Decrement refcount of previous endpoint in
    of_graph_get_next_endpoint
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

-- 
2.1.4

