Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab3DBFFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:05:48 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45558 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759884Ab3DBFFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <1364847069-2887-2-git-send-email-nzimmer@sgi.com>
References: <5159C147.70800@sgi.com>
	<1364847069-2887-1-git-send-email-nzimmer@sgi.com>
	<1364847069-2887-2-git-send-email-nzimmer@sgi.com>
Date: Tue, 2 Apr 2013 10:35:46 +0530
Message-ID: <CAKohpok7MR28trAddHRi5Lcg0bGBHBnOfJO=yu7SQqGnV5ZCRg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] cpufreq: split the cpufreq_driver_lock and use the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 01:41, Nathan Zimmer <nzimmer@sgi.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> +static struct cpufreq_driver __rcu *cpufreq_driver;
> +static DEFINE_SPINLOCK(cpufreq_driver_lock);

You really need this lock? This is only used in cpufreq_register_driver
and unregister_driver... And it doesn't protect other routines at all. And
because we are using rcu stuff now, probably this lock is just not required.

> +static DEFINE_SPINLOCK(cpufreq_data_lock);

Only this one is required and it can be the rwlock which is already pushed
by rafael.
