Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbaGASCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:02:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55994 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaGASCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:02:49 -0400
Message-ID: <53B2F7C3.5060107@codeaurora.org>
Date: Tue, 01 Jul 2014 11:02:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, shawn.guo@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com
Subject: Re: [PATCH 07/14] cpufreq: cpu0: OPPs can be populated at runtime
References: <cover.1404231535.git.viresh.kumar@linaro.org> <1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 09:32, Viresh Kumar wrote:
> OPPs can be populated statically, via DT, or added at run time with
> dev_pm_opp_add().
>
> While this driver handles the first case correctly, it would fail to populate
> OPPs added at runtime. Because call to of_init_opp_table() would fail as there
> are no OPPs in DT and probe will return early.
>
> To fix this, remove error checking and call dev_pm_opp_init_cpufreq_table()
> unconditionally.
>
> Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Please update the binding as well to indicate that this property is now
optional.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

