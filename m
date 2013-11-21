Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3KUP5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:57:54 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51448 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3KUP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:57:51 -0500
MIME-Version: 1.0
In-Reply-To: <3577662.BKCLJdcf18@vostro.rjw.lan>
References: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org>
	<3577662.BKCLJdcf18@vostro.rjw.lan>
Date: Thu, 21 Nov 2013 21:27:51 +0530
Message-ID: <CAKohpo=fZ8Fr=CMDzCy3daBU+mZBJ+9fOks6L7WLOZzE7WaAaQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sripa Bagadia <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2013 18:41, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, November 21, 2013 12:39:02 PM Viresh Kumar wrote:

>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> @@ -1038,6 +1038,32 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,

>> +     if (has_target()) {
>> +             ret = __cpufreq_driver_target(policy, policy->cur,
>> +                             CPUFREQ_RELATION_L);
>> +             if (ret)
>> +                     pr_err("%s: Unable to set frequency from table: %d\n",
>> +                                     __func__, ret);
>
> Should we continue in that case?

I wasn't sure. I thought maybe there are platforms which might not be
ready for transitions so early and so an error message would be fine,
as we will fail soon anyway in case there is a bug.

--
viresh
