Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaCaPAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:00:23 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39405 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:00:21 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.brezillon@overkiz.com, festevam@gmail.com, shawn.guo@linaro.org,
        nicolas.ferre@atmel.com, sebastian.hesselbarth@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] clk: reverse default clk provider initialization order in of_clk_init()
References: <1395917012-23483-1-git-send-email-s.nawrocki@samsung.com>
	<20140329084147.5762.51815@quantum>
Date: Mon, 31 Mar 2014 08:00:18 -0700
In-Reply-To: <20140329084147.5762.51815@quantum> (Mike Turquette's message of
	"Sat, 29 Mar 2014 01:41:47 -0700")
Message-ID: <7h1txi76rh.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Turquette <mturquette@linaro.org> writes:

> Quoting Sylwester Nawrocki (2014-03-27 03:43:32)
>> This restores the default clocks registration order as parsed from
>> devicetree, i.e. as before commit 1771b10d605d26ccee771a7fb4b08718
>> "clk: respect the clock dependencies in of_clk_init", for when there
>> is no explicit parent clock dependencies between clock providers
>> specified in the device tree.
>> 
>> It prevents regressions (boot failure, division by 0 errors) on
>> imx and exynos platforms.
>> 
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> I pulled this into clk-next but it didn't seem to get picked up by
> linux-next in time for today's build. Let's test the next linux-next to
> insure that the regressions are gone. If not then I'll likely need to
> drop "clk: respect the clock dependencies in of_clk_init" from clk-next
> for 3.15.

It looks like all the boot failures caused by this problem are gone as
of next-20140331[1], so it looks good to me.

Kevin

[1] http://lists.linaro.org/pipermail/kernel-build-reports/2014-March/002988.html
