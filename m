Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaI2SDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:03:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45713 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaI2SDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:03:49 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 0/6] Add of-graph helpers to loop over endpoints and find ports by id
Date: Mon, 29 Sep 2014 20:03:33 +0200
Message-Id: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

now the first three patches of the previous series are combined into one. This
patch touches of, media, and staging. Since it is rebased onto Grant's tree, it
now trivially conflicts with 30e94a564d07 (staging: imx-drm: Lines over 80
characters fixed.)

This series converts all existing users of of_graph_get_next_endpoint that pass
a non-NULL prev argument to the function and decrement its refcount themselves
to stop doing that. The of_node_put is moved into of_graph_get_next_endpoint
instead.
This allows to add a for_each_endpoint_of_node helper macro to loop over all
endpoints in a device tree node.
The third of patch adds a of_graph_get_port_by_id function to retrieve a port
by its known port id from the device tree.

Finally, the last three patches convert functions in drm_of.c and imx-drm-core.c
to use the for_each_endpoint_of_node macro instead of of_graph_get_next_endpoint.

Changes since v4:
 - Combined patches 1-3 into one

The previous version can be found here: https://lkml.org/lkml/2014/9/29/78

regards
Philipp

Philipp Zabel (6):
  of: Decrement refcount of previous endpoint in
    of_graph_get_next_endpoint
  of: Add for_each_endpoint_of_node helper macro
  of: Add of_graph_get_port_by_id function
  drm: use for_each_endpoint_of_node macro in drm_of_find_possible_crtcs
  imx-drm: use for_each_endpoint_of_node macro in
    imx_drm_encoder_get_mux_id
  imx-drm: use for_each_endpoint_of_node macro in
    imx_drm_encoder_parse_of

 drivers/gpu/drm/drm_of.c                       |  8 ++----
 drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
 drivers/of/base.c                              | 35 ++++++++++++++++++++------
 drivers/staging/imx-drm/imx-drm-core.c         | 28 ++++++---------------
 include/linux/of_graph.h                       | 18 +++++++++++++
 5 files changed, 56 insertions(+), 36 deletions(-)

-- 
2.1.0

