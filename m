Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaIIPWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:22:09 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:57669 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaIIPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <1410242868-14750-1-git-send-email-mturquette@linaro.org>
References: <1410242868-14750-1-git-send-email-mturquette@linaro.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 9 Sep 2014 17:21:46 +0200
X-Google-Sender-Auth: tne82D7qeBnWPp3nH-hOrxJOkUM
Message-ID: <CAAObsKCmxZLj0V+rECvLGQhqnQuO0zV3NmtFPyMUMEAhV9Pq+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] fixes for struct clk_core migration
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2014 08:07, Mike Turquette <mturquette@linaro.org> wrote:
> A few build issues have popped up with more extensive testing of the
> patches to split the clock framework into a proper provider/consumer
> relationship. [0]
>
> The first patch adapts Intel's LPSS driver to use the clock provider
> APIs. If no one objects to this patch then I will fold it into Tomeu's
> patch #2. [1]
>
> Tomeu, can you run your Coccinelle script again against all of arch/ and
> drivers/ to make sure nothing else was left out?

Sure, I had to add a few new files that are now in linux-next,
including the lpss driver.

I just sent a v10 of my series, but the only changed commit is the
generated one:

https://lkml.kernel.org/r/<1410271497-27148-1-git-send-email-tomeu.vizoso@collabora.com>

Cheers,

Tomeu

> The second patch brings the asm-generic version of clkdev.h up to speed
> with all of the asm-specific versions, by not declaring __clk_get and
> __clk_put if CONFIG_COMMON_CLK is set. If no one objects to this patch
> then I will move it to the front of the patch stack when rebasing
> Tomeu's series.
>
> [0] http://lkml.kernel.org/r/<1409758148-20104-1-git-send-email-tomeu.vizoso@collabora.com>
> [1] http://lkml.kernel.org/r/<1409758317-20564-1-git-send-email-tomeu.vizoso@collabora.com>
>
> Mike Turquette (2):
>   acpi: lpss: convert from struct clk to struct clk_core
>   asm-generic: COMMON_CLK defines __clk_{get,put}
>
>  drivers/acpi/acpi_lpss.c               | 6 +++---
>  include/asm-generic/clkdev.h           | 2 ++
>  include/linux/platform_data/clk-lpss.h | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
