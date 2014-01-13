Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaAMPiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:38:12 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:60444 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaAMPiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:38:11 -0500
Date: Mon, 13 Jan 2014 16:37:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 17/28] drm/i2c: tda998x: set the repeat PLL value in
 range 0..3
Message-ID: <20140113163735.43c1d19b@armhf>
In-Reply-To: <20140111182602.GF15937@n2100.arm.linux.org.uk>
References: <20140109120513.0965ddad@armhf>
	<20140111182602.GF15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 18:26:02 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> >  	div = 148500 / mode->clock;
> > +	if (div != 0) {
> > +		div--;
> > +		if (div > 3)
> > +			div = 3;
> > +	}  
> 
> As the driver currently stands, we know that the clock divider works for
> the lower resolution modes.  So, as things stand, for 74.25MHz modes,
> we get a divisor of one.
> 
> Your patch changes this, the divider becomes zero.  I wonder whether
> you've tested 720p modes at all with this?

In 720p, the divider becomes (148500 / 74250 - 1) = 1 and this mode
works fine.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
