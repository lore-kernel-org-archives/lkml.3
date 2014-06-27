Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaF0CP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 22:15:58 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:43184 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaF0CP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 22:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140627015354.32686.83046@quantum>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
	<e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
	<53AB1CC1.4010907@codeaurora.org>
	<CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
	<53ACB568.4000903@codeaurora.org>
	<20140627015354.32686.83046@quantum>
Date: Fri, 27 Jun 2014 07:45:55 +0530
Message-ID: <CAKohponvN3rAvJrfi4TojFcq5gq7r2oNE4Q0_NtwBHmEZ8waBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2014 07:23, Mike Turquette <mturquette@linaro.org> wrote:
>> but it isn't future-proof if/when the clock framework starts returning
>> dynamically allocated clock pointers for each clk_get() invocation.
>> Maybe we need a function in the common clock framework that tells us if
>> the clocks are the same either via DT or by taking two clock pointers?
>
> I looked through the patch briefly and did not see why we would need to
> do this. Any hint?

We want to know which CPUs are sharing clock line, so that we can
fill affected-cpus field of cpufreq core.
