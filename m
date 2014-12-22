Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaLVPLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:11:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50625 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaLVPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:11:40 -0500
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 0/3] Add of-graph helpers to loop over endpoints and find ports by id
Date: Mon, 22 Dec 2014 16:11:28 +0100
Message-Id: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

next try for v3.20. After the merge window we have a few new users of
of_graph_get_next_endpoint, could I please get some acks from the respective
maintainers for this to go in through Grant's tree?

This series converts all existing users of of_graph_get_next_endpoint that pass
a non-NULL prev argument to the function and decrement its refcount themselves
to stop doing that. The of_node_put is moved into of_graph_get_next_endpoint
instead.
This allows to add a for_each_endpoint_of_node helper macro to loop over all
endpoints in a device tree node.

Changes since v5:
 - Rebased onto v3.19-rc1
 - Added new users of of_graph_get_next_endpoint, coresight and
   drm/rcar-du. There's also rockchip, but the driver already doesn't
   decrement the prev node's reference count.
 - Dropped the "use for_each_endpoint_of_node macro" patches,
   I'll add the new users and resend them separately.

The previous version can be found here: https://lkml.org/lkml/2014/9/29/529

regards
Philipp

Philipp Zabel (3):
  of: Decrement refcount of previous endpoint in
    of_graph_get_next_endpoint
  of: Add for_each_endpoint_of_node helper macro
  of: Add of_graph_get_port_by_id function

 drivers/coresight/of_coresight.c               | 13 ++--------
 drivers/gpu/drm/imx/imx-drm-core.c             | 13 ++--------
 drivers/gpu/drm/rcar-du/rcar_du_kms.c          | 15 +++--------
 drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
 drivers/of/base.c                              | 35 ++++++++++++++++++++------
 include/linux/of_graph.h                       | 18 +++++++++++++
 6 files changed, 55 insertions(+), 42 deletions(-)

-- 
2.1.4

