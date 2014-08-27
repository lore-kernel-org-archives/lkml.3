Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935271AbaH0P4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:56:39 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:37836 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935209AbaH0P4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140827133936.GD6364@lee--X1>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
	<20140827133936.GD6364@lee--X1>
Date: Wed, 27 Aug 2014 08:56:35 -0700
X-Google-Sender-Auth: ZAUdPUGlHI7Yk6f8Ex5xmZTlAp0
Message-ID: <CAD=FV=WAN=WCdMd4hWDr8qzsg3TWTGX_OAa=6KHvyWrqjmk7MA@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Wed, Aug 27, 2014 at 6:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> +static int rk808_probe(struct i2c_client *client,
>> +                    const struct i2c_device_id *id)
>> +{
>> +     int ret;
>> +     int pm_off = 0;
>> +     struct rk808 *rk808;
>> +     struct device_node *np = client->dev.of_node;
>
> Are you prepared for np == NULL?

Given that the driver no longer supports getting its config from
platform data, I think it simply depends on OF now.  It seems like we
could add a "&& OF" to the dependencies.  Is that OK with you?

It doesn't hurt to still add a check for np == NULL and bail out, though.
