Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaCHFao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:30:44 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:60468 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaCHFa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:27 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
In-Reply-To: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
Date: Fri, 07 Mar 2014 18:23:30 +0000
Message-Id: <20140307182330.75168C40AE3@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014 18:13:20 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Mauro, Russell,
> 
> I have temporarily removed the simplified bindings at Sylwester's
> request and updated the branch with the acks. The following changes
> since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> 
>   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> 
> are available in the git repository at:
> 
>   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> 
> for you to fetch changes up to d484700a36952c6675aa47dec4d7a536929aa922:
> 
>   of: Warn if of_graph_parse_endpoint is called with the root node (2014-03-06 17:41:54 +0100)

Nak. I made comments that haven't been resolved yet. I've replied with
more detail tonight. The big issues are how drivers handle the optional
'ports' node and I do not agree to the double-linkage in the binding
description.

g.

> 
> ----------------------------------------------------------------
> Philipp Zabel (6):
>       [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
>       Documentation: of: Document graph bindings
>       of: Warn if of_graph_get_next_endpoint is called with the root node
>       of: Reduce indentation in of_graph_get_next_endpoint
>       [media] of: move common endpoint parsing to drivers/of
>       of: Warn if of_graph_parse_endpoint is called with the root node
> 
>  Documentation/devicetree/bindings/graph.txt   | 129 ++++++++++++++++++++++
>  drivers/media/i2c/adv7343.c                   |   4 +-
>  drivers/media/i2c/mt9p031.c                   |   4 +-
>  drivers/media/i2c/s5k5baf.c                   |   3 +-
>  drivers/media/i2c/tvp514x.c                   |   3 +-
>  drivers/media/i2c/tvp7002.c                   |   3 +-
>  drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
>  drivers/media/platform/exynos4-is/media-dev.c |  13 ++-
>  drivers/media/platform/exynos4-is/mipi-csis.c |   5 +-
>  drivers/media/v4l2-core/v4l2-of.c             | 133 +----------------------
>  drivers/of/base.c                             | 151 ++++++++++++++++++++++++++
>  include/linux/of_graph.h                      |  66 +++++++++++
>  include/media/v4l2-of.h                       |  33 +-----
>  13 files changed, 375 insertions(+), 178 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/graph.txt
>  create mode 100644 include/linux/of_graph.h
> 
> 

