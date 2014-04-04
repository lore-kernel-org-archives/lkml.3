Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaDDPPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:15:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43612 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaDDPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:15:22 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
	<7htxae5plh.fsf@paris.lan>
	<CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w@mail.gmail.com>
Date: Fri, 04 Apr 2014 08:15:19 -0700
In-Reply-To: <CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w@mail.gmail.com>
	(Viresh Kumar's message of "Tue, 1 Apr 2014 10:02:43 +0530")
Message-ID: <7h8urlyvlk.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> On 31 March 2014 21:26, Kevin Hilman <khilman@linaro.org> wrote:
>> Viresh Kumar <viresh.kumar@linaro.org> writes:
>>> +             if (is_pinned) {
>>> +                     pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
>>> +                                     __func__, timer);
>>
>> printk message will be confusing: removing it from what?
>
> Hmm.. So, I am looking to do two modifications here. Just need inputs
> if that would be the right thing to do:
>
> - do a WARN() here as these timers should have been already removed
> - change print to: "can't migrate pinned timer %p, deactivating timer"
>
> Looks fine?

Yes.
