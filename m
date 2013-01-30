Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3A3QvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:51:06 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:43267 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3A3QvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:51:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130130162225.GB30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
	<1359550803-18577-2-git-send-email-fabio.baltieri@linaro.org>
	<CAKohponwQFFtC3MKh72Z0bqYksV_P6D07VivQUYjai1qPB_J9g@mail.gmail.com>
	<20130130162225.GB30559@balto.lan>
Date: Wed, 30 Jan 2013 22:21:03 +0530
Message-ID: <CAKohpoms9AK+j+Au53cwbLn=ds0AsJn+ApUMgMxe2dVhC7McVw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] cpufreq: handle SW coordinated CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 21:53, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> On Wed, Jan 30, 2013 at 08:32:38PM +0530, Viresh Kumar wrote:

>> I believe this routine should be rather present in cpufreq core code,
>> as their might
>> be other users of it. Its really not related to dbs or governors.
>>
>> My ideas about the name of routine then:
>> - policy_is_shared()
>> - or something better you have :)
>
> So you are suggesting to rethink this function to be related to policy
> rather than dbs... this may as well become an inline in cpufreq.h, as:
>
> static inline bool policy_is_shared(struct cpufreq_policy *policy)
> {
>         return cpumask_weight(policy->cpus) > 1;
> }

Perfect.

> I'm not sure about the name through, I like mentioning sw coordination in it
> because that's the comment in the declaration:
>
>         cpumask_var_t           cpus;   /* CPUs requiring sw coordination */
>         cpumask_var_t           related_cpus; /* CPUs with any coordination */
>
> And those two are already confusing as a starting point.

I will fix these comments with a patch of mine.

> Anyway, this sounds fine to me.  If you think this is useful I can send
> a patch, or feel free to include it in your patches if you plan to do
> further cleanup work on this code.
>
> /me tries to also keep that ->cpu field in mind.

You can make it part of your patchsets v8.
