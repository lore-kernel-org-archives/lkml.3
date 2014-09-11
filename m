Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaIKEEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:04:11 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42788 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaIKEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1410401092-8355-1-git-send-email-zyw@rock-chips.com>
References: <1410401092-8355-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 10 Sep 2014 21:04:07 -0700
X-Google-Sender-Auth: G-ySbdurz9GqOpoMGfKPMa44g00
Message-ID: <CAD=FV=UHgyUgzqqbmGWnsjKxbbZcUMC__qfebbHAuj9EkJu18Q@mail.gmail.com>
Subject: Re: [PATCH] RTC: RK808: remove tm_def structure
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        zhangqing <zhangqing@rock-chips.com>, xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 10, 2014 at 7:04 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>

It's good to add a description, like:

If the date/time is invalid at bootup, there's no reason to set it to
a bogus value.  We can just let the data and time be invalid until
someone makes it valid.

> ---
>
>  drivers/rtc/rtc-rk808.c |   17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)

Other than the lack of description, this looks great.  It applies atop
Andrew's patch to make tm_dev "static" and works like a charm.

I tested by hacking the device with:
  i2cset -f -y 0 0x1b 0x10 0xc1
  i2cset -f -y 0 0x1b 3 0x32
  i2cset -f -y 0 0x1b 0x10 0xc0

That made it think it was the 32nd day of the month.  I then rebooted and saw:
  [    3.371853] rk808-rtc rk808-rtc: invalid date/time
  [    3.379115] rk808-rtc rk808-rtc: rtc core: registered rk808-rtc as rtc0
  [    5.411574] rk808-rtc rk808-rtc: hctosys: invalid date/time

I was still able to set the clock.  Once I did it worked fine.


Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
