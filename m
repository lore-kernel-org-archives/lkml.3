Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3J0LR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:17:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47696 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3J0LRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:17:24 -0400
Date: Sun, 27 Oct 2013 12:17:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org,
        "'Beno?t Cousson'" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Message-ID: <20131027111715.GA2437@xo-6d-61-c0.localdomain>
References: <1382446042-27099-1-git-send-email-sre@debian.org>
 <1382446042-27099-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382446042-27099-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add device tree support for twl4030 keypad driver and update the
> Documentation with twl4030 keypad device tree binding information.
> 
> Tested on Nokia N900.

It looks pretty good.

> +++ b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
> @@ -0,0 +1,31 @@
> +* TWL4030's Keypad Controller device tree bindings
> +
> +TWL4030's Keypad controller is used to interface a SoC with a matrix-type
> +keypad device. The keypad controller supports multiple row and column lines.
> +A key can be placed at each intersection of a unique row and a unique column.
> +The keypad controller can sense a key-press and key-release and report the
> +event using a interrupt to the cpu.
> +
> +This binding is based on the matrix-keymap binding with the following
> +changes:
> +
> + * keypad,num-rows and keypad,num-columns are required.

Is "keypad," prefix neccessary here?

> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.

"do not autorepeat". Plus I do not see what is Linux specifc about not
autorepeating... Other systems will likely know about autorepeat, too.

> @@ -324,6 +326,31 @@ static int twl4030_kp_program(struct twl4030_keypad *kp)
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_OF)

I'm probably missing something here, but why not #ifdef CONFIG_OF?

> @@ -381,7 +426,7 @@ static int twl4030_kp_probe(struct platform_device *pdev)
>  
>  	input_set_capability(input, EV_MSC, MSC_SCAN);
>  	/* Enable auto repeat feature of Linux input subsystem */
> -	if (pdata->rep)
> +	if (!kp->no_autorepeat)
>  		__set_bit(EV_REP, input->evbit);
>

Double negation is nasty to read. I believe code would be more
readable if you switched logic to kp->autorepeat.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
