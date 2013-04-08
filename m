Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187Ab3DHKhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:37:09 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49350 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934908Ab3DHKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130403215412.GG3411@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
	<20130403215412.GG3411@htj.dyndns.org>
Date: Mon, 8 Apr 2013 16:07:05 +0530
Message-ID: <CAP245DXTz-EhQqXycUkm5R3O=vpHQ5ZUrddJ40COpnO35oCqwg@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Jens Axboe <axboe@kernel.dk>,
        Robin Randhawa <robin.randhawa@arm.com>,
        linux-rt-users@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        airlied@redhat.com, mingo@redhat.com, davem@davemloft.net,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 3:24 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Viresh.
>
> Sorry about the delay.  Lost this one somehow.
>
> On Mon, Apr 01, 2013 at 12:01:05PM +0530, Viresh Kumar wrote:
>> Just wanted to make this clear before writing it:
>>
>> You want me to do something like (With better names):
>>
>> int wq_unbound_for_power_save_enabled = 0;
>>
>> #ifdef CONFIG_WQ_UNBOUND_FOR_POWER_SAVE
>> #define WQ_UNBOUND_FOR_POWER_SAVE   wq_unbound_for_power_save_enabled
>> #else
>> #define WQ_UNBOUND_FOR_POWER_SAVE 0
>>
>> And provide a call to enable/disable wq_unbound_for_power_save_enabled ??
>
> Not a call, probably a module_param() so that it can be switched
> on/off during boot.  You can make the param writable so that it can be
> flipped run-time but updating existing workqueues would be non-trivial
> and I don't think it's gonna be worthwhile.
>
> Thanks!

Does it make sense to collect this sort of power optimisation under a
CONFIG_PM sub-item, say, CONFIG_PM_OPTIMISATIONS?

For people tuning for power, it could be single place to go enable
stuff and for people looking for performance regressions it would be a
single place to make sure nothing is enabled.

/Amit
