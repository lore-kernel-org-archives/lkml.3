Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3H0QHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:07:30 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:37480 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3H0QH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:07:26 -0400
MIME-Version: 1.0
In-Reply-To: <521CC9B8.2020801@semaphore.gr>
References: <521BA068.8030003@semaphore.gr>
	<CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com>
	<521CC9B8.2020801@semaphore.gr>
Date: Tue, 27 Aug 2013 21:37:25 +0530
Message-ID: <CAKohpo=XhHtRfsVrUZr0DQCK5L5zU_6DB4PBOA4QrJBvvcbe0Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target freq
 in supported range
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 21:16, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> I think we should keep these checks because:
>
> 1) They shorten the execution code (there is no unnecessary call of
> __cpufreq_driver_target)

I don't really count this one.. This is how code is present everywhere in
kernel.. These checks are present in routines and callers don't need to
take care of them..

> 2) In case my patch will be accepted, we need them to avoid continuously
> increase of dbs_info->requested_freq.With my patch the requested_freq
> can temporarily overcome policy->min and policy->max. __cpufreq_driver_target
> will select the correct frequency (within policy->min and policy->max).
> Then, dbs_cpufreq_notifier will adjust requested_freq.

Sorry, I couldn't understand what you meant here :(
