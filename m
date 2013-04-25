Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3DYLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:15:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53523 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYLPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DW3RwTZBXX-gcYKGDcRqrO8E86a9Y1jWNCL2kOO4+UJmA@mail.gmail.com>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
	<CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
	<CAP245DW3RwTZBXX-gcYKGDcRqrO8E86a9Y1jWNCL2kOO4+UJmA@mail.gmail.com>
Date: Thu, 25 Apr 2013 16:45:23 +0530
Message-ID: <CAKohpokU6bkHrWN3ZYQs1SRkyjZwM-hZLzxd-4Ea93gYKZ+u7w@mail.gmail.com>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2013 16:43, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Thu, Apr 25, 2013 at 9:13 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 25 April 2013 09:00, Amit Kucheria <amit.kucheria@linaro.org> wrote:
>>> Yes. That was my intention - preventing a prompt on existing defconfigs and
>>> there by maintaining current behavior.
>>
>> Hmm... Following is the version after fixing all problems you reported.
>> @Tejun: I have attached it too as gmail's copy-paste may break it. Please
>> consider applying this series if it looks fine to you.
>>
>>
>> ---------------x----------------x---------------------
>>
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>> Date: Mon, 8 Apr 2013 16:45:40 +0530
>> Subject: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT for
>>  power oriented workqueues
>>
>> Workqueues can be performance or power-oriented. Currently, most workqueues are
>> bound to the CPU they were created on. This gives good performance (due to cache
>> effects) at the cost of potentially waking up otherwise idle cores just to
>> process some work. To save power, we can allow the work to be rescheduled on a
>> core that is already awake.
>>
>> Workqueues created with the WQ_UNBOUND flag will allow some power savings.
>> However, we don't change the default behaviour of the system.  To enable
>> power-saving behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT needs to
>> be turned on. This option can also be overridden by the
>> workqueue.power_efficient boot parameter.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> For the series, you can add my:
>
> Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

Thanks.
