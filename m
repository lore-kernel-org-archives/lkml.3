Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaI2WLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:11:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaI2WLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:11:43 -0400
Date: Mon, 29 Sep 2014 18:10:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
Message-ID: <20140929221042.GA9895@kroah.com>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:03:34PM +0200, Philipp Zabel wrote:
> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (that is, soc_camera and imx-drm) are changed to not decrement the passed
> prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v4:
>  - Folded patches 1-3 into this one
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
>  drivers/of/base.c                              |  9 +--------
>  drivers/staging/imx-drm/imx-drm-core.c         | 12 ++----------
>  3 files changed, 5 insertions(+), 19 deletions(-)

No objection from me for this, but Grant is in "charge" of
drivers/of/base.c, so I'll leave it for him to apply.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

thanks,

greg k-h
