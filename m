Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaK2T0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 14:26:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41816 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaK2T0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 14:26:10 -0500
Date: Sat, 29 Nov 2014 20:26:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20141129192607.GB17355@amd>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> index 01e9f30..50a8dad 100644
> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> @@ -41,6 +41,62 @@ Optional properties:
>  	 To get more informations, please refer to documentaion.
>  	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>  
> +- led-flash : the LED submodule device node
> +
> +There are two led outputs available - fled1 and fled2. Each of them can
> +control a separate led or they can be connected together to double
> +the maximum current for a single connected led. One led is represented
> +by one child node.
> +
> +Required properties:
> +- compatible : must be "maxim,max77693-flash"
> +
> +Optional properties:
> +- maxim,fleds : array of current outputs in order: fled1, fled2
> +	Note: both current outputs can be connected to a single led
> +	Possible values:
> +		0 - the output is left disconnected,
> +		1 - a diode is connected to the output.

Is this one needed? Just ommit child note if it is not there.

> +- maxim,trigger-type : Array of trigger types in order: flash, torch
> +	Possible trigger types:
> +		0 - Rising edge of the signal triggers the flash/torch,
> +		1 - Signal level controls duration of the flash/torch.
> +- maxim,trigger : Array of flags indicating which trigger can activate given led
> +	in order: fled1, fled2
> +	Possible flag values (can be combined):
> +		1 - FLASH pin of the chip,
> +		2 - TORCH pin of the chip,
> +		4 - software via I2C command.

Is it good idea to have bitfields like this?

Make these required properties of the subnode?
     									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
