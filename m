Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3LZBHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 20:07:42 -0500
Received: from blu0-omc4-s32.blu0.hotmail.com ([65.55.111.171]:10907 "EHLO
	blu0-omc4-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab3LZBHk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 20:07:40 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Dec 2013 20:07:40 EST
X-TMN: [UP7fCs6dhGGrR4eBw475or8sQWOuLHwR]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] Add the LED burst trigger
Date: Wed, 25 Dec 2013 20:02:33 -0500
Importance: Normal
In-Reply-To: <20131225230935.GB13593@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>,<20131225230935.GB13593@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Dec 2013 01:02:33.0570 (UTC) FILETIME=[28C59420:01CF01D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes, Morse code can indicate any means. But when we look at the LEDs, would we like to also have a Morse code book in hand?

The burst led blink idea is because it is easy to use and easy to describe. Mostly when users on site are describing the LEDs states to the support engineer.

Joe

----------------------------------------
> Date: Thu, 26 Dec 2013 00:09:35 +0100
> From: pavel@ucw.cz
> To: lgxue@hotmail.com
> CC: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: Re: [PATCH] Add the LED burst trigger
>
> Hi!
>
>> +Sometimes, the system has only one no-color led to indicate different stats.
>> +The LED timer trigger can let LEDs to blink in different frequency, but most
>> +people maybe just can discriminate two states, slow and fast.
>> +
>> +In this case, Morse code maybe is a good choice :-), but who can bear it.
>> +
>> +Besides the Morse code, another way is using burst mode. People can easily tell
>> +how many times the LED blinks in one cycle.
>
> Would it make sense to make this a bit more capable, including the
> morse code?
>
> Actually... N900 has rather complex LED blinking hardware. (Yes, it
> has dedicated chip that can run simple "programs" for LED blinking).
>
> It would be cool to have reasonable interface for N900 leds... and
> perhaps its subset would work for you, too...
>
> http://wiki.maemo.org/LED_patterns
>
> Pavel
>
>> + on(1/6s)off(1/6s)on(1/6s)off(1/6m)
>> + ...off 500ms...
>> + on(1/6s)off(1/6s)on(1/3s)off(1/6m)
>> + ...off 500ms
>> + ...
>> +
>> + Example 2
>> +
>> + echo burst> trigger
>> + echo 4> freq
>> + echo 3> times
>> + echo 1000> delay_off
>
> Hmm, would something like
>
> echo 40> step_length_ms
> echo "- - - "> pattern
>
> do the same trick?
>
> Plus, you could for example do
>
> echo "- --- "> pattern
>
> to do morse code...
>
> Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/ 		 	   		  