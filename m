Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaA0T7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:59:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50207 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751405AbaA0T7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:59:40 -0500
Date: Mon, 27 Jan 2014 19:59:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/24] drm/i2c: tda998x: set the video mode from the
	adjusted value
Message-ID: <20140127195930.GW15937@n2100.arm.linux.org.uk>
References: <cover.1390646891.git.moinejf@free.fr> <20140125181443.5c079d76@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125181443.5c079d76@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 06:14:43PM +0100, Jean-Francois Moine wrote:
> @@ -896,9 +897,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  	 * TDA19988 requires high-active sync at input stage,
>  	 * so invert low-active sync provided by master encoder here
>  	 */
> -	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
> +	if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
>  		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
> -	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
> +	if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
>  		reg_set(priv, REG_VIP_CNTRL_3, VIP_CNTRL_3_V_TGL);
>  
>  	/*

It looks like this comment from Darren has not been addressed (or
commented on).  Can you discuss this with Darren and come to some sort
of solution please, otherwise applying this patch set is going to cause
a regression.  Thanks.

=8<
Using the adj_mode->flags breaks a workaround I had done on BeagleBone Black    
(tilcdc + tda998x) to resolve an issue with out of spec syncs from the          
tlcdc.  I invert the HSYNC in adj_mode->flags but don't want the tda998x to     
really know that I am doing that so I use adj_mode in the tilcdc driver, and    
mode here in the tda998x driver.  The theory being adj_mode contains whatever   
workarounds I need to do for the driving device and mode has the pristine       
values that I want to send to the monitor.  I would need to look if there is a  
different way to solve this as I am guessing you are actually using adj_mode in 
the manner it was intended.                                                     
                                                                                
Otherwise this patch series is working on BeagleBone Black - I have only tried  
video so far (not audio).                                                       
                                                                                
Darren                                                                          
=8<

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
