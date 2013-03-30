Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3C3SYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:24:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36453 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3C3SYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:24:49 -0400
Date: Sat, 30 Mar 2013 19:24:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ADP1653 board code for Nokia RX-51
Message-ID: <20130330182447.GG28947@amd.pavel.ucw.cz>
References: <201302171616.50152@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302171616.50152@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> +static int __init rx51_camera_hw_init(void)
> +{
> +	int rval;
> +
> +	rval = rx51_adp1653_init();
> +	if (rval)
> +		return rval;
> +
> +	return 0;
> +}

"return rx51_adp1653_init()". Or better yet, rename rx51_adp1653_init
to rx51_camera_hw_init.

Thanks for all the n900 work, btw :-).

> +static struct adp1653_platform_data rx51_adp1653_platform_data = {
> +	.power			 = rx51_adp1653_power,
> +	/* Must be limited to 500 ms in RX-51 */
> +	.max_flash_timeout	 = 500000,		/* us */
> +	/* Must be limited to 320 mA in RX-51 B3 and newer hardware */
> +	.max_flash_intensity	 = ADP1653_FLASH_INTENSITY_REG_TO_mA(19),
> +	/* Must be limited to 50 mA in RX-51 */
> +	.max_torch_intensity	 = > ADP1653_FLASH_INTENSITY_REG_TO_mA(1),

So we do 1mA to be safe?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
