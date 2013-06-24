Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3FXSmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:42:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50890 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:42:37 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-1a-51c8931ab781
Message-id: <51C89319.3080409@samsung.com>
Date: Mon, 24 Jun 2013 20:42:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] clk: Handle CLK_GET_RATE_NOCACHE flag in clk_set_rate()
References: <1371820055-14147-1-git-send-email-s.nawrocki@samsung.com>
 <20130621161627.9136.84494@quantum>
In-reply-to: <20130621161627.9136.84494@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xy7pSk08EGrSeMbY42/SG3WLT42us
	Fpd3zWGzeDrhIpsDi8eda3vYPDYvqffo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujGkdGQWH
	OSqOLnjF2MDYw97FyMEhIWAiceIQTxcjJ5ApJnHh3nq2LkYuDiGBpYwSl1beZYFwPjFK7L34
	gB2kildAS+JMZzMjiM0ioCqxbdcpMJtNwFCi92gfmC0qECCxeMk5qHpBiR+T77GA2CJAvdsO
	tLKB2MwCxRI9c6+A1QgL+Eism/QE7CAhgRyJ+buUQcKcAgYS9983Q5WrS0yat4gZwpaX2Lzm
	LfMERoFZSDbMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghYftlB+PiY1aH
	GAU4GJV4eD/GnQgUYk0sK67MPcQowcGsJMIbKgIU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDi3
	oHuJ7Z8vSzQuCvLM42konPhrSw3730VOC3bZfkm7dCNMNu1IxPLtf4rFue7mx+ssuLfZVYHz
	l927QAk/9XNbRSJYJmrXVR8o6aq8Vm307cRkC4WM5UpXdxzU2j5RO/dDhE91/ObymQmvOA6s
	/N8x2dL7a9S9Nu+lkjHu/T1N5j15MStrZyixFGckGmoxFxUnAgC1/E+8OQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 06:16 PM, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2013-06-21 06:07:35)
>> > If a clock has CLK_GET_RATE_NOCACHE flag set the rate needs to
>> > be recalculated, rather than referencing the cached value.
>> > 
>> > Currently cached clk->rate is compared with new value to see if
>> > anything needs to be done in clk_set_rate(). This may cause required
>> > clock controller registers update to not happen when same clock
>> > frequency value is being set subsequently.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Peter already sent a patch for this:
> https://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=commitdiff;h=34e452a152efd25d654b7bc809df429337115b03

Thanks Mike, that also helps. My apologies for not having
it noticed earlier. I'm going to post a patch for the Exynos
clock driver, which adds missing CLK_GET_RATE_NOCACHE flags to
the ISP clock group and would be really effective together
with the above one.

Thanks,
Sylwester
