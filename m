Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937475Ab3DIKLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:11:39 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35774 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3DIKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DWzD7BqB6ZzQJp8iUTpucRUeFbq=xEh+5fr2TqXVuwgAw@mail.gmail.com>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
	<CAP245DUWtryaxn=u=VWiSp7b9RZYjsEozX9WEHCvzMWJR6B7TQ@mail.gmail.com>
	<CAKohpomtRYfGcEq9b1NmZwha4XA2=HaKsOiyShWScJi0+szfiw@mail.gmail.com>
	<CAP245DWzD7BqB6ZzQJp8iUTpucRUeFbq=xEh+5fr2TqXVuwgAw@mail.gmail.com>
Date: Tue, 9 Apr 2013 15:41:37 +0530
Message-ID: <CAKohpok6D7UfFTWkdeJWVE_SjG_TRwhGuVF8nq6Lr5XvomZ6Ew@mail.gmail.com>
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

On 9 April 2013 15:28, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Tue, Apr 9, 2013 at 3:25 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> But how will we know if the user of wq wants to save power or not? He must
>> give some flag which is only used when power saving is enabled. We can't
>> set WQ_UNBOUND for all wqs.
>
> You have the Kconfig option + the module param for that. You don't need a flag.

I still don't agree.. Suppose there are three users A, B and C. A wants to use
WQ_UNBOUND when POWER_EFFICIENT Kconfig option and module param is
enabled. And B always want to enable WQ_UNBOUND and C doesn't want to
set WQ_UNBOUND at all..

Now, how will each of these behave differently based on module param settings.
B and C are quite clear but A needs a flag for indicating its usage.
