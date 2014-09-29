Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaI2UkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:40:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58824 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2UkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:40:08 -0400
Date: Mon, 29 Sep 2014 22:40:04 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, Andreas Mohr <andi@lisas.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ES938 support for ES18xx driver
Message-ID: <20140929204004.GA5037@rhlx01.hs-esslingen.de>
References: <1412020242-8752-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412020242-8752-1-git-send-email-linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 29, 2014 at 09:50:42PM +0200, Ondrej Zary wrote:
> +	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT)
> +		/* no error if this fails because ES938 is optional */
> +		if (snd_es938_init(&chip->es938, card, 0, 0) == 0)
> +			snd_printk(KERN_DEBUG "found ES938 audio processor\n");
> +
> +	return 0;

Hmm, how's the braces policy here?
Given a double "if" I'd suspect that the outer "if" would want braces then.
(perhaps checkpatch.pl has something to say here)

Not to mention that I'm having strong doubts about the kernel's
"if" coding style guidelines in general:
IMHO *all* uses of "if" ought to be braced:
witness the Apple-specific OpenSSL bug catastrophy ("goto fail;"),
where people said that adding braces to conditionals would have made things
obvious.
Plus the annoyance that for an addition commit to an existing conditional
the diff will *not* contain the addition only (one line),
but rather *three* lines, and the first line rather needlessly getting
modified even!

+ if (is_foo)
+   bar;

So, given a ridiculously simple one-line addition:

- if (is_foo)
+ if (is_foo) {
    bar;
+   boo;
+ }

Rather than:

+ if (is_foo) {
+   bar;
+ }

if (is_foo) {
  bar;
+ boo;
}


(SIX changed lines vs. 4!)


Not to mention my pet peeve about large sections of coding style documents -
they establish Golden Rules to never be broken, but then
Fail To Elaborate Why - STUPID!
(that does not fully apply to our "if" CodingStyle paragraph though)
What a great way to hamper properly thought out evolution of guidelines...

Perhaps we should have a seasoned discussion about that coding style issue,
and others? (any update of Documentation/CodingStyle
would need to directly include an update to checkpatch.pl, too, though)

(sorry about that part being rather OT to your particular nice patch)

> +	struct snd_es938_sysex_reg req = {
> +		.midi_cmd = MIDI_CMD_COMMON_SYSEX,
> +		.id = ES938_ID,
> +		.cmd = ES938_CMD_REG_R,
> +		.reg = reg,
> +		.midi_end = MIDI_CMD_COMMON_SYSEX_END,
> +	};

Hmm, perhaps const? :)
(and dito probably a const void * cast further below, to forego receiving
the optionally activated gcc non-const cast warnings)

> +	end_time = ktime_add_ms(ktime_get(), 100);

Yay! One driver less which is advertising
less precise deprecated implementation style :)

> +	/* check if the reply is our and has SYSEX_END at the end */

"ours"

Thanks,

Andreas Mohr
