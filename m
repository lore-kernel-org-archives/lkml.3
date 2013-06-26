Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3FZOcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:32:32 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59173 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130626142852.GA2326@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
	<CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
	<20130625161935.GA10208@jshin-Toonie>
	<CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
	<20130626142852.GA2326@jshin-Toonie>
Date: Wed, 26 Jun 2013 20:02:29 +0530
Message-ID: <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 19:58, Jacob Shin <jacob.shin@amd.com> wrote:
> On Wed, Jun 26, 2013 at 12:18:27PM +0530, Viresh Kumar wrote:

>> I am not sure if this is enough. What if we had ondemand as the
>> governor initially, then we changed it to something else. Now also
>> cur_policy contains a address and isn't zero.
>
> Right, so we check below ..
>
>>
>> >                 cpumask_or(&done, &done, policy->cpus);
>> > +
>> > +               if (policy->governor != &cpufreq_gov_ondemand)
>> > +                       continue;
>
> This should catch that case no ?

Policy might be freed and reallocated by then. And so doing
policy->governor is dangerous.
