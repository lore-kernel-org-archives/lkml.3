Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaETR1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:27:23 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57905 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaETR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Tue, 20 May 2014 19:27:18 +0200
Message-ID: <CA+gwMccr8N+oZA4A5DY168Vis0Q6OaVDJuJaWzRVTQ389ixjjQ@mail.gmail.com>
Subject: Re: [PATCHv2 resend 00/11] improve PWM lookup support without device tree
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Mon, May 19, 2014 at 10:42 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Hi,
>
> Originally sent on Apr 14th, note that this series is blocking another 16
> patches series, I would like it to be taken in 3.16 if we can agree on this
> implementation.
>
> A patch set as suggested by Thierry to make lookup with the lookup table
> instead of device tree behave more like when using device tree.
>
> The first patch adds a period and a polarity member to the lookup table and use
> those to set period and polarity.
>
> Patch 2, 4 and 5 are making use of those new members from the board files.
> Patch 3 removes useless code since setting the polarity is now handled by the
> PWM core.
>
> I couldn't decide on a good name for the extended PWM_LOOKUP macro and I believe
> we won't have to add members to that structure soon so:
> Patch 6 modifies the PWM_LOOKUP macro to also initialize period and polarity
> and
> Patch 7-9 are making use of the new PWM_LOOKUP macro in the board files
>
> Patch 10 and 11 are making the leds-pwm and pwm_bl drivers get the period from
> the PWM before using pwm_period_ns if it is not already set.
>
> Patch 10 will obviously conflict with the series of Russell reworking the
> leds-pwm probing. I can rebase if necessary
>
> The final goal would be to get rid of .pwm_period_ns in leds-pwm and pwm_bl
> after moving all the remaining users (still around 25) to pwm_lookup.
>
> Changes in v2:
>  - correctly unlock the pwm_lookup_lock mutex before returning.
>  - don't change PWM_LOOKUP atomically
>  - remove tpu_pwm_platform_data and the associated header file
>  - make the leds-pwm and pwm_bl drivers get the period from the PWM
>
> Alexandre Belloni (11):
>   pwm: add period and polarity to struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: initialize all struct pwm_lookup
>     members
>   pwm: renesas-tpu: remove useless struct tpu_pwm_platform_data
>   ARM: OMAP3: Beagle: initialize all the struct pwm_lookup members
>   ARM: pxa: hx4700: initialize all the struct pwm_lookup members
>   pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
>   ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: use PWM_LOOKUP to initialize struct
>     pwm_lookup
>   ARM: pxa: hx4700: use PWM_LOOKUP to initialize struct pwm_lookup
>   leds: leds-pwm: retrieve configured pwm period
>   backlight: pwm_bl: retrieve configured pwm period

For the hx4700 patches (5 an 9),
Acked-by: Philipp Zabel <philipp.zabel@gmail.com>

regards
Philipp
