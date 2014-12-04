Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbaLDSnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:43:22 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42274 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141204184046.GL7944@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
	<1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
	<20141203111518.GB1039@katana>
	<CAD=FV=X5inPWZakhgDX0dX=1CWXygEi3_AH9FVFWXYT3LZA5bg@mail.gmail.com>
	<20141204184046.GL7944@katana>
Date: Thu, 4 Dec 2014 10:43:19 -0800
X-Google-Sender-Auth: 5rUOYghFS_RVLeYqFzLzhSmpbZ0
Message-ID: <CAD=FV=Vp3hwxbDzb+FUhNXy8qW8fTCkgd67jRDV3foT0o9HQuQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, caesar <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Thu, Dec 4, 2014 at 10:40 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> If you don't read all the below, my belief is that we should simply
>> rename the strings in Addy's patch.  We should change "rise-ns" to
>> "i2c-scl-rising-time" and "fall-ns" to "i2c-scl-falling-time".
>> Wolfram: can you confirm this is OK?  I'm voting to leave the "-ns"
>> off the end of both to avoid asymmetry.
>
> New binding should have the "-ns" suffix, right? So, I'd vote to add the
> suffix to the new bindings and deprecate the ones used in the designware
> driver: "i2c-scl-rising-time-ns" and "i2c-scl-falling-time-ns"
>
> It might be a little more work now, but it will help us in the future,
> because it is the correct way to do it.

OK, that sounds fair.  You're OK with my proposal otherwise?

Are you looking for Addy or me to submit a patch supporting the "-ns"
suffix on the Designware i2c driver, or should we just use the "-ns"
suffix in the Rockchip driver and assume someone will later add
support for the new binding in the Designware i2c driver?

-Doug
