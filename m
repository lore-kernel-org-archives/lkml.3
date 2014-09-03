Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaICVaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:30:39 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51135 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaICVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1409763853-29778-1-git-send-email-zyw@rock-chips.com>
References: <1409752307-29044-1-git-send-email-zyw@rock-chips.com>
	<1409763853-29778-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 3 Sep 2014 14:30:36 -0700
X-Google-Sender-Auth: haF4dZBGGWS0vpMczaK5alJvGug
Message-ID: <CAD=FV=XPUEJDUKg-A+sJZY-Y71D6LkXogpKpNjc0JL+QjAT0Dg@mail.gmail.com>
Subject: Re: [PATCH v8 3/5] RTC: RK808: add RTC driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 3, 2014 at 10:04 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> +       rk808_rtc->irq = platform_get_irq(pdev, 0);
> +       if (rk808_rtc->irq <= 0) {
> +               dev_err(&pdev->dev, "Wake up is not possible as irq = %d\n",
> +                       rk808_rtc->irq);
> +               return -ENXIO;
> +       }

You missed some of my feedback (though your changelog says otherwise).
Note: it would probably be good to also only print if it's not
EPROBE_DEFER.

Thus, the above should be:

       rk808_rtc->irq = platform_get_irq(pdev, 0);
       if (rk808_rtc->irq < 0) {
               if (rk808_rtc->irq != -EPROBE_DEFER)
                   dev_err(&pdev->dev, "Wake up is not possible as irq = %d\n",
                           rk808_rtc->irq);
               return rk808_rtc->irq;
       }
