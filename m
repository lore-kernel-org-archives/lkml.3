Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaKSFOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:14:49 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53095 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaKSFOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <1416367554-15185-1-git-send-email-caesar.wang@rock-chips.com>
References: <1416367554-15185-1-git-send-email-caesar.wang@rock-chips.com>
Date: Tue, 18 Nov 2014 21:14:46 -0800
X-Google-Sender-Auth: yxlhXEEnp-j6jgPyvKZhXHpHfOc
Message-ID: <CAD=FV=W+WU3j7OWKTxtGUv1Jt7qPesGXSOsoM=bsD5C15jttvA@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: fix PWM clock found on RK3288 Socs
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        ZhenFu Fang <fzf@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <chris.zhong@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

On Tue, Nov 18, 2014 at 7:25 PM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> We use the new PWM IP on RK3288,but the PWM's clock indeed incorrect.
>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Right, I reported this when Kever was doing his "unused clocks" patch.
That's why this clock is currently "ignore unused".

...but though your change is right, I'd rather your change doesn't
land quite yet.  It totally wrecks havoc with the PWM regulator used
on many rk3288 boards and will glitch the main "logic" voltage at
bootup.  I have some patches that are MASSIVELY WIP:

https://chromium-review.googlesource.com/230640
WIP: regulator: pwm: Tell regulator framework that we can't turn off

https://chromium-review.googlesource.com/230641
WIP: PWM: handle the fact that firmware might have left us enabled

https://chromium-review.googlesource.com/230642
WIP: pwm-regulator stuff

I think that last one might blow up into several patches.  We need to
solve the problems from those patches before yours can really land.


It's pretty high on my list to finish the above patches, but right now
suspend/resume issues are higher priority so it's a bit stalled...  If
someone wants to hijack any of the above patches please let me know--I
won't be offended.

-Doug
