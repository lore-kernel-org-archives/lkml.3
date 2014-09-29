Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaI2Jpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:45:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI2Jpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:45:34 -0400
Message-ID: <1411983923.3050.1.camel@pengutronix.de>
Subject: Re: [PATCH v4 1/8] [media] soc_camera: Do not decrement endpoint
 node refcount in the loop
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Mon, 29 Sep 2014 11:45:23 +0200
In-Reply-To: <20140929091316.GA23154@mwanda>
References: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
	 <1411978551-30480-2-git-send-email-p.zabel@pengutronix.de>
	 <20140929091316.GA23154@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 29.09.2014, 12:13 +0300 schrieb Dan Carpenter:
> On Mon, Sep 29, 2014 at 10:15:44AM +0200, Philipp Zabel wrote:
> > In preparation for a following patch, stop decrementing the endpoint node
> > refcount in the loop. This temporarily leaks a reference to the endpoint node,
> > which will be fixed by having of_graph_get_next_endpoint decrement the refcount
> > of its prev argument instead.
> 
> Don't do this...
> 
> My understanding (and I haven't invested much time into trying to
> understand this beyond glancing at the change) is that patch 1 and 2,
> introduce small bugs that are fixed in patch 3?
>
> Just fold all three patches into one patch.  We need an Ack from Mauro
> and Greg and then send the patch through Grant's tree.

Yes. Patches 1 and 2 leak a reference on of_nodes touched by the loop.
As far as I am aware, all users of this code don't use the reference
counting (CONFIG_OF_DYNAMIC is disabled), so this bug should be
theoretical.

I'd be happy do as you suggest if Mauro and Greg agree.

regards
Philipp

