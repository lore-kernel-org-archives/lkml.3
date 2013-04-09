Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937013Ab3DIJfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:35:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55257 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DUTV2v2XZe-z0SVx_PW15ob65qoX8zbP7DX=9vjS_Mu4Q@mail.gmail.com>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
	<CAP245DUTV2v2XZe-z0SVx_PW15ob65qoX8zbP7DX=9vjS_Mu4Q@mail.gmail.com>
Date: Tue, 9 Apr 2013 15:05:16 +0530
Message-ID: <CAKohpomZFK77w-9fE_Z7WArpJspk3kp15tJ+e-5BER_oZjo9ag@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Robin Randhawa <robin.randhawa@arm.com>,
        linux-rt-users@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steve Bannister <Steve.Bannister@arm.com>, airlied@redhat.com,
        Arvind Chauhan <arvind.chauhan@arm.com>, mingo@redhat.com,
        davem@davemloft.net,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 14:48, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Tue, Apr 9, 2013 at 1:00 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
>> +config WQ_POWER_EFFICIENT
>> +       bool "Workqueue allocated as UNBOUND for power efficiency"
>> +       depends on PM
>
> Should default to N so that existing configs don't get prompted for a choice.

I thought defaults default is N if not present. I can add default n if
it is required.

>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> +static bool wq_power_efficient = 0;
>
> 1?

It should be disabled by default even if CONFIG_WQ_POWER_EFFICIENT is
selected and so initialized it with zero.. Though i don't need to
initialize it as
default is 0.
