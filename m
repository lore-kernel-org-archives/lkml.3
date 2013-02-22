Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3BVCog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:44:36 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50917 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3BVCoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:44:32 -0500
MIME-Version: 1.0
In-Reply-To: <3793635.ht6rIgi6nV@vostro.rjw.lan>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<2852709.b79tkCt2uQ@vostro.rjw.lan>
	<CAKohpompwGaJziPcrwqH2pUgpiOPa1is_z0506+hO06FXQ8MFA@mail.gmail.com>
	<3793635.ht6rIgi6nV@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 08:14:30 +0530
Message-ID: <CAKohponsBt8Pa-uXHJPjy6zBt0DNVJL7=zqZWXJZ-bR1to2WBg@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 07:59, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 22, 2013 07:44:23 AM Viresh Kumar wrote:

>> If you don't like this one then we can add another entry
>> into struct policy like: gov_sysfs_parent.
>
> I don't know.  This is going to look kind of ugly this way or another I think.
>
> Maybe I'll figure out something ...

Another simple way of doing this is, leave this patch and here is why i say so.

struct policy is allocated dynamically with kzalloc and so every field is zero
including have_multiple_policies. And only the platforms needing this feature
would make it 1 and all remaining ones would stay unchanged.

This variable would waste just "4" bytes for platforms that don't need this
feature.

About performance: This if/else is called only on policy creation or
destruction.
For platforms that doesn't have multiple policies and thus all cpus share the
same policy struct, the destruction might never happen unless we rmmod/insmod
cpufreq driver, because policy destruction would only happen when all the cpus
are removed :)

So it will execute only once at boot time when we initialize policy struct.

Is this patch worth keeping then?

--
viresh
