Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3HVGxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:53:05 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:59190 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab3HVGxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:53:03 -0400
Date: Thu, 22 Aug 2013 08:53:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input
 configuration
Message-ID: <20130822085313.2e8b1ae6@armhf>
In-Reply-To: <20130821223605.GA6617@n2100.arm.linux.org.uk>
References: <20130821202646.47af66a5@armhf>
	<20130821223605.GA6617@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 23:36:05 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
> > no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
> > of the Dove lcd for RGB or YUV formats).
> > 
> > Which board needs a special VIP configuration?  
> 
> If you run the NXP driver, and then run this driver, things get messed
> up - which has already been covered months ago when this patch was first
> brought up.
> 
> It's there to ensure that the TDA998x is correctly configured no matter
> what it's previous state is, and prevent the thing being fragile as hell.

The NXP driver will never go to the mainline, so, I don't see the
problem. If you want to use it to test some other drivers, you should
better patch it instead of adding useless code in the TDA998x driver.

> No, reset doesn't restore its settings, only a power cycle does.

Sorry, all VIP control registers may be changed at any time and the
change appears immediately (thank you for the /sys i2c_read/write).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
