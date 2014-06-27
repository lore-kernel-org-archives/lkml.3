Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaF0ByJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 21:54:09 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44117 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaF0ByH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 21:54:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53ACB568.4000903@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shawn Guo" <shawn.guo@linaro.org>,
        "Lists linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Arvind Chauhan" <arvind.chauhan@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, "Sachin Kamat" <spk.linux@gmail.com>,
        "Thomas P Abraham" <thomas.ab@samsung.com>,
        "Nishanth Menon" <nm@ti.com>, "Tomasz Figa" <t.figa@samsung.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Mark Rutland" <Mark.Rutland@arm.com>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
 <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
 <53AB1CC1.4010907@codeaurora.org>
 <CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
 <53ACB568.4000903@codeaurora.org>
Message-ID: <20140627015354.32686.83046@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
Date: Thu, 26 Jun 2014 18:53:54 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2014-06-26 17:06:00)
> Finally, checking for equivalent pointers from clk_get() will work now,

Please don't do that. Even though it works for the current
implementation, comparing those pointers from a driver violates how
clkdev is supposed to work. The pointer returned by clk_get should only
be dereferenced by a driver to check if it is an error code. Anything
besides an error code is no business of the driver.

> but it isn't future-proof if/when the clock framework starts returning
> dynamically allocated clock pointers for each clk_get() invocation.
> Maybe we need a function in the common clock framework that tells us if
> the clocks are the same either via DT or by taking two clock pointers?

I looked through the patch briefly and did not see why we would need to
do this. Any hint?

Thanks,
Mike

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
