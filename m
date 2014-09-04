Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaIDRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:33:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40328 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaIDRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:33:11 -0400
Date: Thu, 4 Sep 2014 10:33:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v9 1/3] RTC: RK808: add RTC driver for RK808
Message-ID: <20140904173300.GC10224@core.coreip.homeip.net>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
 <1409793159-2573-2-git-send-email-zyw@rock-chips.com>
 <CAD=FV=U8XK945vJTnsY8FG3+WasOrMnoCYOF+b360HTyXVccfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=U8XK945vJTnsY8FG3+WasOrMnoCYOF+b360HTyXVccfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:18:42PM -0700, Doug Anderson wrote:
> Chris,
> 
> On Wed, Sep 3, 2014 at 6:12 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> > Adding RTC driver for supporting RTC device present inside RK808 PMIC.
> >
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> > Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> >
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> 
> 
> > +       rk808_rtc->irq = platform_get_irq(pdev, 0);
> > +       if (rk808_rtc->irq < 0) {
> > +               dev_err(&pdev->dev, "Wake up is not possible as irq = %d\n",
> > +                       rk808_rtc->irq);
> 
> Technically you shouldn't print the error if it's -EPROBE_DEFER.
> ...but I think that's really unlikely here (I can't imagine any real
> cases where the interrupt parent for RK808 would actually be deferred)
> so I won't push it.

Doug, platform_get_irq() simply iterates through IRQ resources assigned to the
device, which are populated at platform device creation time. The only error it
returns ever is -ENXIO, so we are fine here.

Thanks.

-- 
Dmitry
