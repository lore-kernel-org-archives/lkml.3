Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaAGV2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:28:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43157 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaAGV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:28:03 -0500
Date: Tue, 7 Jan 2014 22:28:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
Message-ID: <20140107212801.GA26665@amd.pavel.ucw.cz>
References: <52CA7ABB.4010401@gmail.com>
 <52CBF476.3070306@ti.com>
 <52CC62B7.3030004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC62B7.3030004@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ok, after looking at what both N900 and N9 Nokia kernels do, I came
> up with the patch bellow. If you are ok with the changes, I'll
> submit the patch as it should. With that patch I tried more than 20
> videos of different resolutions(including 720p), not a single
> failure :) . Basically it changes the core clock calculation to be
> done in the same way as in the Nokia kernels.

Thanks for the investigation.


> +again:
> +		if(*five_taps)

>From a quick view, you may want to add space after if.

> +		if(*five_taps && error) {
> +			*five_taps = false;
> +			goto again;
> +		}

Here too.

>  		error = (error || in_width > maxsinglelinewidth * 2 ||
>  			(in_width > maxsinglelinewidth && *five_taps) ||
> @@ -2226,7 +2240,7 @@ static int
> dispc_ovl_calc_scaling_34xx(unsigned long pclk, unsigned long lclk,
>  	} while (*decim_x <= *x_predecim && *decim_y <= *y_predecim && error);
> 
>  	if (check_horiz_timing_omap3(pclk, lclk, mgr_timings, pos_x, width,
> -				height, out_width, out_height)){
> +				height, out_width, out_height, *five_taps)){

...and before {.

(calc_scaling... that function has 16 arguments. Whoever created
it should be shot... or sold to Microsoft ;-).

								Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
