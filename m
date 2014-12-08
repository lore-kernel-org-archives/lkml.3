Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaLHSxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:53:47 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62824 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaLHSxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:53:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141208173432.GA5732@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
	<1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
	<20141208085202.GA13486@pengutronix.de>
	<CAD=FV=V=PDPiDhDmd+j8ePsF43EvuFP-LxKgMKo7ZRBzSMyOJA@mail.gmail.com>
	<20141208173432.GA5732@katana>
Date: Mon, 8 Dec 2014 10:53:44 -0800
X-Google-Sender-Auth: BmK0J1CDQYnGnn3EUpGUaPAR8S4
Message-ID: <CAD=FV=WQypHthEDPGUqVX3kzfFBSdj4H+_QY_=WYA3R77H+WiQ@mail.gmail.com>
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Addy Ke <addy.ke@rock-chips.com>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tao Huang <huangtao@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jianqun Xu <xjq@rock-chips.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        caesar <caesar.wang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Shunqian Zheng <zhengsq@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 8, 2014 at 9:34 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> > There are different capitalisation of i2c in the patch and the commit log. I
>> > don't know what Wolfram prefers here, but using the same spelling
>> > everywhere would be nice.
>>
>> Can you please point out?  IIRC you should always capitalize I2C in
>> prose (descriptions, comments, documentation, etc).  However when used
>> in places which specific capitalization standards it should be
>> lowercase.  That means file names, directory names, device tree
>> property names, etc should be lower case.
>
> This is what I prefer, too. However, I am not too strict about it.
> I mean, both are readable.

Glad my understanding is OK.  :)

>
>> >> +     /* Read rise and fall ns; if not there use the default max from spec */
>> >> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time-ns",
>> >> +                              &i2c->rise_ns)) {
>> >> +             if (i2c->scl_frequency <= 100000)
>> >> +                     i2c->rise_ns = 1000;
>> >> +             else
>> >> +                     i2c->rise_ns = 300;
>> >> +     }
>> >> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-time-ns",
>> >> +                              &i2c->fall_ns))
>> >> +             i2c->fall_ns = 300;
>> >> +
>> > I don't know if other drivers do the same (I assume they should). If so,
>> > moving this logic into the core would be nice. I guess this can still be
>> > done later.
>
> Let's leave that for later. If we do it, we should start with bus speed
> setting first, probably.

OK, great.


So just to summarize for Addy, I think you're being asked to spin one more time.

1. Update the patch description as per Uwe.  Fix other typos pointed out by him.

2. Since you're spinning anyway, adjust "i2c" capitalization to "I2C".

3. If you agree with Uwe, rename spec_max_data_hold_ns to
spec_data_valid_ns.  If not, we should debate in a followup patch.

4. If you think spec_data_hold_buffer_ns could be better represented
in another way (should this be i2c-sda-falling-time-ns"?), please do
so.  If not, we should debate in a followup patch.

-Doug
