Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaCJE05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:26:57 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38788 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaCJE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <2327882.a9zobM63G6@vostro.rjw.lan>
References: <1393965735-15610-1-git-send-email-aplattner@nvidia.com>
	<2327882.a9zobM63G6@vostro.rjw.lan>
Date: Mon, 10 Mar 2014 12:26:53 +0800
Message-ID: <CAKohpo=6_msNGszSQB5_s0PP5O=V44P0vrWpLSe9S+=DQcmipA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: use cpufreq_cpu_get to avoid cpufreq_get race conditions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Aaron Plattner <aplattner@nvidia.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2014 09:23, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, March 04, 2014 12:42:15 PM Aaron Plattner wrote:
>> If a module calls cpufreq_get while cpufreq is initializing, it's possible for
>> it to be called after cpufreq_driver is set but before cpufreq_cpu_data is
>> written during subsys_interface_register.  This happens because cpufreq_get
>> doesn't take the cpufreq_driver_lock around its use of cpufreq_cpu_data.
>
> Is this a theoretical race, or can you actually reproduce it?  If so, on what
> system/driver?  Or are there any bug reports related to this you can point me
> to?
>
>> Fix this by using cpufreq_cpu_get(cpu) to look up the policy rather than reading
>> it out of cpufreq_cpu_data directly.  cpufreq_cpu_get takes the appropriate
>> locks to prevent this race from happening.
>>
>> Since it's possible for policy to be NULL if the caller passes in an invalid CPU
>> number or calls the function before cpufreq is initialized, delete the
>> BUG_ON(!policy) and simply return 0.  Don't try to return -ENOENT because that's
>> negative and the function returns an unsigned integer.
>>
>> Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
>
> Viresh, have you seen this?

Sorry for being late. Though I see you have already applied this one,
I will still add this for records :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
