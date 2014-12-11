Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbaLKTWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:22:35 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42333 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694AbaLKTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <1418295760-19639-1-git-send-email-addy.ke@rock-chips.com>
References: <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
	<1418295760-19639-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 11 Dec 2014 11:22:31 -0800
X-Google-Sender-Auth: 2CQGv_nVZgNwoEjKBWniCRe5UaM
Message-ID: <CAD=FV=UCQMRLx2KHzT28iY6uCHGQ0MouWKEeVyv2AF_qNCrT=Q@mail.gmail.com>
Subject: Re: [PATCH v5] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C specification
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, caesar <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 11, 2014 at 3:02 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>   - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.
> + - i2c-scl-rising-time-ns : Number of nanoseconds the signal takes to rise
> +       (t(r) in I2C specification). If not specified this is assumed to be
> +       the maximum the specification allows(1000 ns for Standard-mode,
> +       300 ns for Fast-mode) which might cause slightly slower communication.
> + - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
> +       (t(f) in the I2C specification). If not specified this is assumed to
> +       be the maximum the specification allows (300 ns) which might cause
> +       slightly slowercommunication.

nit: you forgot a space between "slower" and "communication".

...this is the type of thing I think Wolfram can fixup when applying,
so I'd suggest against respinning unless something else is needed.

Overall I continue to be happy with this patch.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

You'll notice that I posted a patch atop it at
<https://patchwork.kernel.org/patch/5477201/>.

-Doug
