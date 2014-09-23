Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaIWXnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:43:17 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51166 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaIWXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <1411487622-10881-2-git-send-email-zyw@rock-chips.com>
References: <1411487622-10881-1-git-send-email-zyw@rock-chips.com>
	<1411487622-10881-2-git-send-email-zyw@rock-chips.com>
Date: Tue, 23 Sep 2014 16:43:14 -0700
X-Google-Sender-Auth: 3ijf08BoPpeGYKsyTxEB9fuCDuQ
Message-ID: <CAD=FV=Vhejf4JoEPUGwmBJdO+zfHgE5hgoT6V1DGtva7r_1Etg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Sep 23, 2014 at 8:53 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Get voltage & duty table from device tree might be better, other platforms can also use this
> driver without any modify.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

I finally managed to get everything setup and I've now tested this
myself on an rk3288-based board.

Tested-by: Doug Anderson <dianders@chromium.org>

I'd imagine the next step is for Lee to comment on the patch and when
he's happy with it Mark Brown will land it?


One thing that's still a bit odd (though no different than the
behavior of the driver from before you touched it, so it shouldn't
block landing IMHO) is that at boot time this regulator will report
that it's at the highest voltage but the voltage won't actually change
until the first client sets the voltage.

Also: if anyone reading is interested in this patch, it's possible
you'll also be interested in my patch at
<https://patchwork.kernel.org/patch/4960731/> to make sue that your
voltage doesn't twiddle around at probe time.


-Doug
