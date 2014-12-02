Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbaLBXCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:02:40 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58730 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaLBXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
Date: Tue, 2 Dec 2014 15:02:37 -0800
X-Google-Sender-Auth: zKpdu8Rw_Ci_aopOXFGqQD6dzrg
Message-ID: <CAD=FV=WN3Tuzby0fVOyxJ14iroBcgEpWHaz7Rh7EyfrHijhV0A@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Thu, Nov 6, 2014 at 12:11 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
> high_ns calculated from the low division of CLKDIV register is the sum of
> actual measured high_ns and rise_ns. The rise time which related to
> external pull-up resistor can be up to the maximum rise time in I2C spec.
>
> In my test, if external pull-up resistor is 4.7K, rise_ns is about 700ns.
> So the actual measured high_ns is about 3900ns, which is less than 4000ns
> (the minimum high_ns in I2C spec).

It's a little unfortunate to have to make the assumption that the rise
time for a board is going to be the maximum the spec allows.  I think
this is something that's better to let a board specify in the device
tree.  Allowing us to specify it also gives us a little extra slop and
makes it easier to specify a "fall time" without affecting the
resulting frequency.  Right now your code assumes that the fall time
is 0.

I've prototyped what things could look like if the rise and fall times
were specified in the device tree.  You can see my patch (atop yours)
at:

https://chromium-review.googlesource.com/#/c/232774/

...perhaps you could squash that into your patch and post up v2?

-Doug
