Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbbAIRlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:41:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37101 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbAIRlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:41:01 -0500
Date: Fri, 9 Jan 2015 18:40:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v10 02/19] Documentation: leds: Add description of
 LED Flash class extension
Message-ID: <20150109174058.GC18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816989-1808-3-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The documentation being added contains overall description of the
> LED Flash Class and the related sysfs attributes.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
> +must be defined in the kernel config. A flash LED driver must register
> +in the LED subsystem with led_classdev_flash_register function to gain flash
> +related capabilities.
> +
> +There are flash LED devices which can control more than one LED and allow for
> +strobing the sub-leds synchronously. A LED will be strobed synchronously with
> +the one whose identifier is written to the flash_sync_strobe sysfs attribute.
> +The list of available sub-led identifiers can be read from the

sub-LED?

> +	- flash_fault - bitmask of flash faults that may have occurred
> +			possible flags are:
> +		* 0x01 - flash controller voltage to the flash LED has exceeded
> +			 the limit specific to the flash controller
> +		* 0x02 - the flash strobe was still on when the timeout set by
> +			 the user has expired; not all flash controllers may
> +			 set this in all such conditions
> +		* 0x04 - the flash controller has overheated
> +		* 0x08 - the short circuit protection of the flash controller
> +			 has been triggered
> +		* 0x10 - current in the LED power supply has exceeded the limit
> +			 specific to the flash controller
> +		* 0x20 - the flash controller has detected a short or open
> +			 circuit condition on the indicator LED
> +		* 0x40 - flash controller voltage to the flash LED has been
> +			 below the minimum limit specific to the flash
> +		* 0x80 - the input voltage of the flash controller is below
> +			 the limit under which strobing the flash at full
> +			 current will not be possible. The condition persists
> +			 until this flag is no longer set
> +		* 0x100 - the temperature of the LED has exceeded its allowed
> +			  upper limit

Did not everyone agree that text strings are preferable to bitmasks?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
