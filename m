Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaJLVYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 17:24:11 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:44351 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaJLVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 17:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <5700320.9GSb6erCFz@typ>
References: <1412837235-4202-1-git-send-email-addy.ke@rock-chips.com>
	<5700320.9GSb6erCFz@typ>
Date: Sun, 12 Oct 2014 14:24:06 -0700
X-Google-Sender-Auth: jP8rpweSfyO17HKL-WYe7sxsj5o
Message-ID: <CAD=FV=XHOuQZPOrVRtoTGN2Yq6E7fuKSa+AM6U_MYKAoZ+nKBA@mail.gmail.com>
Subject: Re: [PATCH v4] i2c: rk3x: adjust the LOW divison based on
 characteristics of SCL
From: Doug Anderson <dianders@chromium.org>
To: Max Schwarz <max.schwarz@online.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

On Sun, Oct 12, 2014 at 5:10 AM, Max Schwarz <max.schwarz@online.de> wrote:
>> +     /* Adjust to avoid overflow */
>> +     i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000);
>> +     scl_rate_khz = DIV_ROUND_UP(scl_rate, 1000);
>
> I'm not really comfortable with using DIV_ROUND_UP on the last line, since
> this may violate the user's set SCL rate. Rounding up 1.1kHz SCL rate to 2kHz
> is not good.

Ah, good point.  So we round up for i2c_rate and down for scl_rate:

  i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000);
  scl_rate_khz = scl_rate / 1000;


> I suggest using scl_rate / 1000 and placing a
>
> if(WARN_ON(scl_rate < 1000))
>   scl_rate = 1000;
>
> somewhere to prevent scl_rate_khz from becoming 0.

Ah, makes sense.  Yeah, that should be at the top.
