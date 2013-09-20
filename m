Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3ITRIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:08:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53049 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3ITRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokdyk9hfBreVeXttN23biTVjWiJRm8eYkfAjLz+cbnreQ@mail.gmail.com>
References: <1379654772-10700-1-git-send-email-yinghai@kernel.org>
	<CAKohpokdyk9hfBreVeXttN23biTVjWiJRm8eYkfAjLz+cbnreQ@mail.gmail.com>
Date: Fri, 20 Sep 2013 10:08:07 -0700
X-Google-Sender-Auth: lmyk9QFbjmr75ymTb0A0reeUM3U
Message-ID: <CAE9FiQUXGtNeAS70Mr6Nscax26dRoXTCyb28gz1iX2j1s8Nojw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: skip loading acpi_cpufreq after intel_pstate
From: Yinghai Lu <yinghai@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:10 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 September 2013 10:56, Yinghai Lu <yinghai@kernel.org> wrote:
>> If the hw support intel_pstate and acpi_cpufreq, intel_pstate will
>> get loaded at first.
>
> s/at //
>
>>
>> acpi_cpufreq_init will call acpi_cpufreq_early_init()
>> and it allocate perf data and init those perf data in ACPI core, (that
>
> s/it /that will /
>
>> will go over all cpus).
>
> s/go over/cover/
>
>> but late it will free them as cpufreq_register_driver(acpi_cpufreq) will
>
> s/late/later
>
>> return fail as init_pstate already take over before.
>
> write it as: fail as intel_pstate is already registered.
>
>> Use cpufreq_get_current_driver() to check if we can skip the
>> acpi_cpufreq loading.
>
> The below material looks to be a separate issue and so we
> probably break this patch into two?

ok, check that.

Thanks

Yinghai
