Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaI2RAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:00:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaI2RAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:00:33 -0400
Date: Mon, 29 Sep 2014 12:59:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de, Grant Likely <grant.likely@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/8] [media] soc_camera: Do not decrement endpoint
 node refcount in the loop
Message-ID: <20140929165937.GB13163@kroah.com>
References: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
 <1411978551-30480-2-git-send-email-p.zabel@pengutronix.de>
 <20140929091316.GA23154@mwanda>
 <1411983923.3050.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411983923.3050.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:45:23AM +0200, Philipp Zabel wrote:
> Am Montag, den 29.09.2014, 12:13 +0300 schrieb Dan Carpenter:
> > On Mon, Sep 29, 2014 at 10:15:44AM +0200, Philipp Zabel wrote:
> > > In preparation for a following patch, stop decrementing the endpoint node
> > > refcount in the loop. This temporarily leaks a reference to the endpoint node,
> > > which will be fixed by having of_graph_get_next_endpoint decrement the refcount
> > > of its prev argument instead.
> > 
> > Don't do this...
> > 
> > My understanding (and I haven't invested much time into trying to
> > understand this beyond glancing at the change) is that patch 1 and 2,
> > introduce small bugs that are fixed in patch 3?
> >
> > Just fold all three patches into one patch.  We need an Ack from Mauro
> > and Greg and then send the patch through Grant's tree.
> 
> Yes. Patches 1 and 2 leak a reference on of_nodes touched by the loop.
> As far as I am aware, all users of this code don't use the reference
> counting (CONFIG_OF_DYNAMIC is disabled), so this bug should be
> theoretical.
> 
> I'd be happy do as you suggest if Mauro and Greg agree.

Let's see the correct patch, don't break things and then later on fix
them...

thanks,

greg k-h
