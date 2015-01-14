Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbbANShE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:37:04 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43444 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbbANShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:37:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAPz6YkW4icehT6P9EicP1Eww_Ny0hNaeS53WXaFei+HrYbPQ3A@mail.gmail.com>
References: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
	<CAPz6YkW4icehT6P9EicP1Eww_Ny0hNaeS53WXaFei+HrYbPQ3A@mail.gmail.com>
Date: Wed, 14 Jan 2015 10:36:59 -0800
X-Google-Sender-Auth: fLAScxDKiHEbOJpq6XUHpOBMLKM
Message-ID: <CAD=FV=UDj08jkOCDVJ1Q+EanrBHwP_-88XMXojPjY8iB3i-AQA@mail.gmail.com>
Subject: Re: [PATCH] RTC: RK808: fix the rtc time reading issue
From: Doug Anderson <dianders@chromium.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonny,

> Chris, it looks like you swapped the set and the clear of this bit,
> and you're relying on the fact that the i2c transaction takes a
> certain amount of time after the RTC_GET_TIME BIT is set.   I'm not
> sure how long it actually takes, but why not just put in a usleep()
> for the minimum wait time?

I think we are safe.

At 400kHz (the max speed of this part) each bit can be transferred no
faster than 2.5us.  In order to do a valid i2c transaction we need to
_at least_ write the address of the device and the data onto the bus,
which is 16 bits.  16 * 2.5us = 40us.  That's above the 31.25us

Personally I think what Chris has is fine, with the comment.

-Doug
