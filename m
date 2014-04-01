Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaDAEcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:32:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61714 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaDAEco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <7htxae5plh.fsf@paris.lan>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
	<7htxae5plh.fsf@paris.lan>
Date: Tue, 1 Apr 2014 10:02:43 +0530
Message-ID: <CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w@mail.gmail.com>
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2014 21:26, Kevin Hilman <khilman@linaro.org> wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
>> +             if (is_pinned) {
>> +                     pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
>> +                                     __func__, timer);
>
> printk message will be confusing: removing it from what?

Hmm.. So, I am looking to do two modifications here. Just need inputs
if that would be the right thing to do:

- do a WARN() here as these timers should have been already removed
- change print to: "can't migrate pinned timer %p, deactivating timer"

Looks fine?
