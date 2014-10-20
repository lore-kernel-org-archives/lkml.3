Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaJTRhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:37:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:40959 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJTRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <54453F2E.1080401@collabora.co.uk>
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
	<CAD=FV=UtwNjyx56QtRrEo=jbX_PeMRAYZJVXzxqeS-vs4JyGRg@mail.gmail.com>
	<54453F2E.1080401@collabora.co.uk>
Date: Mon, 20 Oct 2014 10:36:58 -0700
X-Google-Sender-Auth: 7eVC8Luy3t2xUv-jhYpHwTY1PVw
Message-ID: <CAD=FV=WJfjhb9pfNhQwpToddR67NpA+m6kkj5oUVE5ewEhzvVQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zhong <zyw@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Oct 20, 2014 at 9:58 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>> It turns out that regulator_suspend_finish() actually returns an error
>> code.  Could you print a warning if you see it?
>>
>
> Yes, I noticed this when looking at Chris patch for Rockchip but didn't re-spin
> because I'm not sure anymore if this is the right solution. I mean, if is
> correct to add the same calls on every platform or if the regulator suspend
> prepare and finish functions should be called from the suspend core instead.
>
> For example calling regulator_suspend_prepare() from platform_suspend_prepare()
> [0] will have the advantage of passing the correct suspend_state_t state instead
> of hard-coding PM_SUSPEND_MEM and will make the regulator suspend states to work
> on all platforms.

Yes.  If we can get this added to the core that would be better.

I guess I was just trying to follow the suggestion that was in the
regulator code:
http://lxr.free-electrons.com/source/drivers/regulator/core.c#L3699
that says "This will usually be called by machine suspend code prior
to supending."

-Doug
