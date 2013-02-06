Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3BFBmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:42:16 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39233 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3BFBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-2-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-2-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:12:10 +0530
X-Google-Sender-Auth: 60Q-GyKuRFpZW_OVPwu3t4Wbsao
Message-ID: <CAOh2x=n4NJhM3_JBpbOgbuOiFkh_fB+cshYcvCeBxUphXLNdRA@mail.gmail.com>
Subject: Re: [PATCH 1/7] cpufreq: Don't remove sysfs link for policy->cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
>
> "cpufreq" directory in policy->cpu is never created using sysfs_create_link(),
> but using kobject_init_and_add(). And so we shouldn't call sysfs_remove_link()
> for policy->cpu(). sysfs stuff for policy->cpu is automatically removed when we
> call kobject_put() for dying policy.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Its already included by Rafael, don't include it in your next version:

commit 73bf0fc2b03d1f4fdada0ec430dc20bfb089cfd5
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Feb 5 22:21:14 2013 +0100

    cpufreq: Don't remove sysfs link for policy->cpu

    "cpufreq" directory in policy->cpu is never created using
    sysfs_create_link(), but using kobject_init_and_add(). And so we
    shouldn't call sysfs_remove_link() for policy->cpu().  sysfs stuff
    for policy->cpu is automatically removed when we call kobject_put()
    for dying policy.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
