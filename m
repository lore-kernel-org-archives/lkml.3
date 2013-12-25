Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3LYXJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 18:09:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53699 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3LYXJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 18:09:37 -0500
Date: Thu, 26 Dec 2013 00:09:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: lgxue@hotmail.com
Cc: cooloney@gmail.com, rpurdie@rpsys.net, rob@landley.net, milo.kim@ti.com,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add the LED burst trigger
Message-ID: <20131225230935.GB13593@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +Sometimes, the system has only one no-color led to indicate different stats.
> +The LED timer trigger can let LEDs to blink in different frequency, but most
> +people maybe just can discriminate two states, slow and fast.
> +
> +In this case, Morse code maybe is a good choice :-), but who can bear it.
> +
> +Besides the Morse code, another way is using burst mode. People can easily tell
> +how many times the LED blinks in one cycle.

Would it make sense to make this a bit more capable, including the
morse code?

Actually... N900 has rather complex LED blinking hardware. (Yes, it
has dedicated chip that can run simple "programs" for LED blinking).

It would be cool to have reasonable interface for N900 leds... and
perhaps its subset would work for you, too...

http://wiki.maemo.org/LED_patterns

									Pavel

> +     on(1/6s)off(1/6s)on(1/6s)off(1/6m)
> +     ...off 500ms...
> +     on(1/6s)off(1/6s)on(1/3s)off(1/6m)
> +     ...off 500ms
> +     ...
> +
> +     Example 2
> +
> +     echo burst > trigger
> +     echo 4 > freq
> +     echo 3 > times
> +     echo 1000 > delay_off

Hmm, would something like

echo 40 > step_length_ms
echo "- - -          " > pattern

do the same trick?

Plus, you could for example do

echo "- ---        " > pattern

to do morse code...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
