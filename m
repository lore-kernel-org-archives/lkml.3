Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaGIOoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:44:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52294 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGIOoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:44:14 -0400
Message-ID: <53BD5523.2080404@ti.com>
Date: Wed, 9 Jul 2014 10:43:47 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't registered
 yet
References: <cover.1404231535.git.viresh.kumar@linaro.org> <eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org> <20140702055330.GA3454@dragon> <CAKohpomzPHRghqHD7-tDbj0gXzc=ANEb3qLv2kRKOZUyqatBew@mail.gmail.com> <CAKohpomk-pyv6Risyq_b8h3DJNGxBoUWu1Y9cApvoz3CwOtL=w@mail.gmail.com> <53B4A607.7030001@codeaurora.org> <CAKohpok0wt46-odR1+KiLLi9=iv+jvAozny9906UND6AgwBgJA@mail.gmail.com>
In-Reply-To: <CAKohpok0wt46-odR1+KiLLi9=iv+jvAozny9906UND6AgwBgJA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014 10:19 PM, Viresh Kumar wrote:
> On 3 July 2014 06:08, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Please make this a dev_dbg() or just remove it entirely. Sending a
>> message to the log on probe defer just duplicates what the driver core
>> is already doing.
> 
> Updated as:
> 
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Thu Jun 26 10:40:21 2014 +0530
> 
>     cpufreq: cpu0: print relevant error when we defer probe
> 
>     Currently, we defer probe if regulator_get() returned -EPROBE_DEFER, i.e.
>     regulator isn't registered yet. We do a dev_err() in this case. Sending a
>     message to the log on probe defer just duplicates what the driver core is
>     already doing. Convert it to dev_dbg() instead.
> 
>     We should defer in case of clk_get() as well.
> 
>     Current code already does it, but it wasn't intentional probably.
> Its just that
>     we are returning the right error with wrong print message.
> 
>     Fix print message to convey right error.
> 
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
Looks good to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

