Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbbAIUyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:54:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbAIUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:54:36 -0500
Date: Fri, 9 Jan 2015 21:54:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v10 15/19] media: Add registration helpers for V4L2
 flash sub-devices
Message-ID: <20150109205432.GP18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-16-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816989-1808-16-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-09 16:23:05, Jacek Anaszewski wrote:
> This patch adds helper functions for registering/unregistering
> LED Flash class devices as V4L2 sub-devices. The functions should
> be called from the LED subsystem device driver. In case the
> support for V4L2 Flash sub-devices is disabled in the kernel
> config the functions' empty versions will be used.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

> +	/*
> +	 * Indicator leds, unlike torch leds, are turned on/off basing
> on

leds -> LEDs.

> +	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY control only.
> +	 * Therefore it must be possible to set it to 0 level which in
> +	 * the LED subsystem reflects LED_OFF state.
> +	 */
> +	if (cdata_id != INDICATOR_INTENSITY)
> +		++__intensity;

And normally we'd do i++ instead of ++i, and avoid __ for local
variables...?

> +/**
> + * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
> + * @intensity:			constraints for the led in a non-flash mode
> + * @flash_intensity:		V4L2_CID_FLASH_INTENSITY settings constraints
> + * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
> + * @flash_faults:		possible flash faults
> + * @has_external_strobe:	external strobe capability
> + * @indicator_led:		signifies that a led is of indicator type
> + */
> +struct v4l2_flash_ctrl_config {
> +	struct v4l2_ctrl_config intensity;
> +	struct v4l2_ctrl_config flash_intensity;
> +	struct v4l2_ctrl_config flash_timeout;
> +	u32 flash_faults;
> +	bool has_external_strobe:1;
> +	bool indicator_led:1;
> +};

I don't think you are supposed to do boolean bit arrays.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
