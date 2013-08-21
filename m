Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3HUWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:37:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3HUWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:37:25 -0400
Date: Wed, 21 Aug 2013 23:36:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input
	configuration
Message-ID: <20130821223605.GA6617@n2100.arm.linux.org.uk>
References: <20130821202646.47af66a5@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821202646.47af66a5@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:26:46PM +0200, Jean-Francois Moine wrote:
> On Wed Aug 14 12:43:29 PDT 2013, Sebastian Hesselbarth wrote:
> > From: Russell King <rmk+kernel at arm.linux.org.uk>
> > 
> > The video-input-port (VIP) is highly configurable. This prepares
> > current driver to allow to configure VIP configuration, as some
> > boards connect lcd controller and TDA998x "pin-swapped" and depend
> > on VIP to swap the pins by register configuration.
> > 
> > Signed-off-by: Russell King <rmk+kernel at arm.linux.org.uk>
> > Tested-by: Darren Etheridge <detheridge at ti.com>
> > Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth at gmail.com>
> 	[snip]
> 
> AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
> no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
> of the Dove lcd for RGB or YUV formats).
> 
> Which board needs a special VIP configuration?

If you run the NXP driver, and then run this driver, things get messed
up - which has already been covered months ago when this patch was first
brought up.

It's there to ensure that the TDA998x is correctly configured no matter
what it's previous state is, and prevent the thing being fragile as hell.
No, reset doesn't restore its settings, only a power cycle does.
