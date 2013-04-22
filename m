Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3DVGUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:20:07 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36352 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3DVGUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130409183020.GD6186@mtj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
	<20130409183020.GD6186@mtj.dyndns.org>
Date: Mon, 22 Apr 2013 11:50:04 +0530
Message-ID: <CAKohpok_pLyVruwq6JLO95cqobpyYgsQnii0sB0oSh5j=rj-=A@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2013 00:00, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Apr 09, 2013 at 01:00:59PM +0530, Viresh Kumar wrote:

>> +#ifdef CONFIG_WQ_POWER_EFFICIENT
>> +static bool wq_power_efficient = 0;
>> +module_param_named(power_efficient, wq_power_efficient, bool, 0444);
>> +#endif
>
> I don't think we need to make the whole thing configurable.  Turning
> it off isn't gonna save much - my gut tells me it's gonna be four
> instructions. :)
>
> What I meant was that the default value for the parameter would
> probably be need to be configurable so that mobile people don't have
> to include the kernel param all the time or patch the kernel
> themselves.

I didn't get it completely.. Are you asking to set the default value
to 1 instead
to keep it enabled by default if config option is selected?
