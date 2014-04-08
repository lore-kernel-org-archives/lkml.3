Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaDHUnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:43:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57616 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbaDHUnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140408070259.68923987@ipc1.ka-ro>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
	<20140402055350.GX17250@pengutronix.de>
	<20140407113652.GE26985@ulmo>
	<20140408070259.68923987@ipc1.ka-ro>
Date: Tue, 8 Apr 2014 13:43:22 -0700
Message-ID: <CAAYSxhpqe1BVDigMKQ18qEpYNyHGFQ6n5cXWdnUO7HZKSCwzWQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
From: Tim Kryger <tim.kryger@linaro.org>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 10:02 PM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> Thierry Reding wrote:

>> No. You cannot emulate polarity inversion in software.
>>
> Why not?
>
> duty_ns = period_ns - duty_ns;

Since I made the same mistake, I will pass along the pointer Thierry gave me.

In include/linux/pwm.h the second difference for an inverted signal is
described.

/**
 * enum pwm_polarity - polarity of a PWM signal
 * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
 * cycle, followed by a low signal for the remainder of the pulse
 * period
 * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
 * cycle, followed by a high signal for the remainder of the pulse
 * period
 */
enum pwm_polarity {
PWM_POLARITY_NORMAL,
PWM_POLARITY_INVERSED,
};

Of course, I suspect not all PWM hardware respects this definition of
inverted output.

Either way, hacking the duty in software certainly would get the
high/low order wrong.

-Tim
