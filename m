Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3GEABa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:01:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42764 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab3GEAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:01:29 -0400
Date: Fri, 5 Jul 2013 09:01:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH] gpio: em: Add pinctrl support
Message-ID: <20130705000123.GC25112@verge.net.au>
References: <20130703041432.7351.45970.sendpatchset@w520>
 <2134291.KQ1KkPOaiZ@avalon>
 <20130704011601.GB13029@verge.net.au>
 <2390194.haUC6IOiqJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2390194.haUC6IOiqJ@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 11:23:33PM +0200, Laurent Pinchart wrote:
> Hi Simon,
> 
> On Thursday 04 July 2013 10:16:02 Simon Horman wrote:
> > On Wed, Jul 03, 2013 at 08:59:39PM +0200, Laurent Pinchart wrote:
> > > On Wednesday 03 July 2013 13:14:32 Magnus Damm wrote:
> > > > From: Magnus Damm <damm@opensource.se>
> > > > 
> > > > Register the GPIO pin range, and request and free GPIO pins using the
> > > > pinctrl API. The pctl_name platform data member should be used by
> > > > platform devices to point out which pinctrl device to use.
> > > > 
> > > > Follows same style as "dc3465a gpio-rcar: Add pinctrl support",
> > > > by Laurent Pinchart, thanks to him.
> > > > 
> > > > Signed-off-by: Magnus Damm <damm@opensource.se>
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > Linus, now that the v3.12 development cycle will begin, would you like to
> > > take the patch through your tree ? If so, how should we handle
> > > cross-dependencies between the pinctrl/gpio tree and the Renesas ARM tree
> > > ?
> > 
> > In the case of this patch I believe that any dependencies that are present
> > in the renesas tree have been merged into the arm-soc tree and thus should
> > appear in v3.11-rcX, where X most likely equals 2 or 3.
> > 
> > That being so v3.11-rcX could be used as a base.
> > 
> > Alternatively its likely that one the renesas-*-for-v3.11 tags in my renesas
> > tree, all of which have been merged into arm-soc and should appear in v3.11-
> > rcX, could be used as a base.
> > 
> > I'm unsure which one as I'm unsure what the dependencies are but I strongly
> > suspect that renesas-gpio-rcar2-for-v3.11 would be a good choice.
> 
> I haven't expressed myself clearly, sorry about that. This particular patch is 
> fine. My point was that it adds a new field to the gpio-em platform data 
> structure. We will thus pretty soon see patches for board code to use that 
> field, so you will need to merge a stable pinctrl branch that includes this 
> patch into your tree.
> 
> We may also encounter similar situations in the reverse direction (pinctrl 
> patches that depend on ARM patches) in the future, we should be prepared for 
> that as well.

Thanks, I now understand.

I think that in general there are two approaches that I am comfortable.

1. For Linus to provide a stable branch or tag for me to use as a base.

2. For me to provide Acks and for Linus to take board patches through
   his tree.

In the reverse case I am happy with the reverse of either of the two
options above, though for one of my branches or tags to be stable
ideally it would need to have been pulled into arm-soc.
