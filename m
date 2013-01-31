Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3AaIba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:31:30 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50143 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3AaIb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:31:28 -0500
MIME-Version: 1.0
In-Reply-To: <1359620064-14751-1-git-send-email-fabio.baltieri@linaro.org>
References: <1359620064-14751-1-git-send-email-fabio.baltieri@linaro.org>
Date: Thu, 31 Jan 2013 14:01:27 +0530
Message-ID: <CAKohponV-PPO8sqF=rzONLzPi7q-YFOPbrQgoBcNt_NjTJO6WQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: implement generic policy_is_shared
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 13:44, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Implement a generic helper function policy_is_shared() to replace the
> current dbs_sw_coordinated_cpus() at cpufreq level, so that it can be
> used by code other than cpufreq governors.
>
> Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 2 +-
>  drivers/cpufreq/cpufreq_governor.c     | 8 --------
>  drivers/cpufreq/cpufreq_governor.h     | 1 -
>  drivers/cpufreq/cpufreq_ondemand.c     | 2 +-
>  include/linux/cpufreq.h                | 5 +++++

Great,

But, you missed few places:

drivers/cpufreq/acpi-cpufreq.c:        if (bios_with_sw_any_bug &&
cpumask_weight(policy->cpus) == 1) {
drivers/cpufreq/cpufreq_stats.c:       if (policy &&
(cpumask_weight(policy->cpus) == 1)) {

get these fixed too and add my

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
