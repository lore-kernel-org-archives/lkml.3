Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaI2JQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:16:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20729 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2JQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:16:37 -0400
Date: Mon, 29 Sep 2014 12:13:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v4 1/8] [media] soc_camera: Do not decrement endpoint
 node refcount in the loop
Message-ID: <20140929091316.GA23154@mwanda>
References: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
 <1411978551-30480-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411978551-30480-2-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:15:44AM +0200, Philipp Zabel wrote:
> In preparation for a following patch, stop decrementing the endpoint node
> refcount in the loop. This temporarily leaks a reference to the endpoint node,
> which will be fixed by having of_graph_get_next_endpoint decrement the refcount
> of its prev argument instead.

Don't do this...

My understanding (and I haven't invested much time into trying to
understand this beyond glancing at the change) is that patch 1 and 2,
introduce small bugs that are fixed in patch 3?

Just fold all three patches into one patch.  We need an Ack from Mauro
and Greg and then send the patch through Grant's tree.

regards,
dan carpenter

