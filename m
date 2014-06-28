Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaF1RH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:07:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44429 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaF1RHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:07:19 -0400
Date: Sat, 28 Jun 2014 19:07:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
Message-ID: <20140628170709.GB23634@xo-6d-61-c0.localdomain>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
 <1403660878-56350-3-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403660878-56350-3-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The non-DT support has to be maintained for now to not break
> OMAP3 legacy boot, and the legacy-style code will be cleaned
> up once OMAP3 is also converted to DT-boot only.

> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
>  	return 0;
>  }
>  
> +static const struct omap_mbox_device_data omap2_data = {
> +	.num_users	= 4,
> +	.num_fifos	= 6,
> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> +};
> +
> +static const struct omap_mbox_device_data omap3_data = {
> +	.num_users	= 2,
> +	.num_fifos	= 2,
> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> +};
> +
> +static const struct omap_mbox_device_data am335x_data = {
> +	.num_users	= 4,
> +	.num_fifos	= 8,
> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
> +};

So you use compatible strings to look up 3 integers. Would it be better to have
num_users/num_fifos/intr_type directly in the device tree? That should be cleaner
and more flexible...

If you do that, would it be possible to have share compatible string?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
