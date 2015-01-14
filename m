Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbbANSjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:39:43 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33337 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbbANSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:39:42 -0500
MIME-Version: 1.0
In-Reply-To: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
References: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 14 Jan 2015 10:39:41 -0800
X-Google-Sender-Auth: b6vsuhembe9kwRpe68u0yYoDeGQ
Message-ID: <CAD=FV=UBSBmCo3GpKN0pkdmkbT27hPp4akPoZG0hSGdpEwa_jg@mail.gmail.com>
Subject: Re: [PATCH] RTC: RK808: fix the rtc time reading issue
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Jan 13, 2015 at 6:43 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> +       /* After we set the GET_TIME bit, the rtc time couldn't be read
> +        * immediately, we should wait up to 31.25 us, about one cycle of
> +        * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
> +        * certainly more than 31.25us.
> +        */

No idea what Andrew thinks of this, but other multiline comments in
this file look slightly different (there's a line containing just /*).


>         ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>                                  BIT_RTC_CTRL_REG_RTC_GET_TIME,
> -                                BIT_RTC_CTRL_REG_RTC_GET_TIME);
> +                                0);
>         if (ret) {
>                 dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
>                 return ret;

Above is just a nit.  I'll leave it up to Andrew to say whether he
wants you to spin, or he'll fix it up, or he doesn't care and he'll
land it as-is.

Reviewed-by: Doug Anderson <dianders@chromium.org>
