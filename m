Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaHSNDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:03:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51125 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaHSNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:02:57 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/5] Add of-graph helpers to loop over endpoints and find ports by id
Date: Tue, 19 Aug 2014 15:02:38 +0200
Message-Id: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.0.rc1
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series converts all existing users of of_graph_get_next_endpoint that pass
a non-NULL prev argument to the function and decrement its refcount themselves
to stop doing that. The of_node_put is moved into of_graph_get_next_endpoint
instead.
This allows to add a for_each_endpoint_of_node helper macro to loop over all
endpoints in a device tree node.
The third of patch adds a of_graph_get_port_by_id function to retrieve a port
by its known port id from the device tree.
Finally, the last three patches convert functions in drm_of.c and imx-drm-core.c
to use the for_each_endpoint_of_node macro instead of of_graph_get_next_endpoint.

regards
Philipp

Philipp Zabel (8):
  [media] soc_camera: Do not decrement endpoint node refcount in the
    loop
  imx-drm: Do not decrement endpoint node refcount in the loop
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
 drivers/media/platform/soc_camera/soc_camera.c |  2 +-
 drivers/of/base.c                              | 39 ++++++++++++++++++++------
 drivers/staging/imx-drm/imx-drm-core.c         | 34 +++++++---------------
 include/linux/of_graph.h                       | 11 ++++++++
 5 files changed, 55 insertions(+), 39 deletions(-)

-- 
2.1.0.rc1

