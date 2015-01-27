Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbbA0WhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:37:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51798 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbbA0WhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:37:12 -0500
Date: Tue, 27 Jan 2015 23:37:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com
Subject: Reading /sys with side effects (was Re: [PATCH 1/2] Documentation:
 leds: Add description of LED Flash class extension)
Message-ID: <20150127221958.GA18993@amd>
References: <1422346028-16739-1-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422346028-16739-1-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +	- flash_fault - list of flash faults that may have occurred:
> +		* led-over-voltage - flash controller voltage to the flash LED
> +			has exceededthe limit specific to the flash controller
> +		* flash-timeout-exceeded - the flash strobe was still on when
> +			the timeout set by the user has expired; not all flash
> +			controllers may set this in all such conditions
> +		* controller-over-temperature - the flash controller has
> +			overheated
> +		* controller-short-circuit - the short circuit protection
> +			of the flash controller has been triggered
> +		* led-power-supply-over-current - current in the LED power
> +			supply has exceeded the limit specific to the flash
> +			controller
> +		* indicator-led-fault - the flash controller has detected
> +			a short or open circuit condition on the indicator LED
> +		* led-under-voltage - flash controller voltage to the flash
> +			LED has been below the minimum limit specific to
> +			the flash
> +		* controller-under-voltage - the input voltage of the flash
> +			controller is below the limit under which strobing the
> +			flash at full current will not be possible. The condition
> +			persists until this flag is no longer set
> +		* led-over-temperature - the temperature of the LED has exceeded
> +			its allowed upper limit
> +
> +		Flash faults are cleared, if possible, by reading the attribute.

That's bad. Now you can no longer present flash_fault file as readable
to non-root users, and grep -ri foo /sys will interfere with your
camera application.

Bad interface, just fix it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
