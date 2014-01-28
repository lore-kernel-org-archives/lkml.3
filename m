Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaA1RMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:12:14 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:46490 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaA1RMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:12:12 -0500
Date: Tue, 28 Jan 2014 18:12:18 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Darren Etheridge <detheridge@ti.com>
Cc: <dri-devel@lists.freedesktop.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v3 07/24] drm/i2c: tda998x: set the video mode from the
 adjusted value
Message-ID: <20140128181218.39d1d15e@armhf>
In-Reply-To: <20140123232907.GA25988@ti.com>
References: <cover.1390153344.git.moinejf@free.fr>
	<20140119195840.1ecab03b@armhf>
	<20140123232907.GA25988@ti.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 17:29:07 -0600
Darren Etheridge <detheridge@ti.com> wrote:

> > @@ -896,9 +897,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
> >  	 * TDA19988 requires high-active sync at input stage,
> >  	 * so invert low-active sync provided by master encoder here
> >  	 */
> > -	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
> > +	if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
> >  		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
> > -	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
> > +	if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
> >  		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
> >    
> 
> Using the adj_mode->flags breaks a workaround I had done on BeagleBone Black
> (tilcdc + tda998x) to resolve an issue with out of spec syncs from the
> tlcdc.  I invert the HSYNC in adj_mode->flags but don't want the tda998x to
> really know that I am doing that so I use adj_mode in the tilcdc driver, and
> mode here in the tda998x driver.  The theory being adj_mode contains whatever
> workarounds I need to do for the driving device and mode has the pristine
> values that I want to send to the monitor.  I would need to look if there is a
> different way to solve this as I am guessing you are actually using adj_mode in
> the manner it was intended.

No. In fact, I just wanted the function to use only one mode.

Looking at the other drivers, it seems that they don't touch the
adjusted_mode, so, for the Cubox, mode and adjusted_mode have same
values.

I will do an other patch so that you will not have to touch the tilcdc
driver.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
