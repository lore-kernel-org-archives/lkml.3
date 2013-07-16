Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3GPIvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:51:31 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59594 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3GPIv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <1372927830-2949-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-2-git-send-email-l.majewski@samsung.com>
Date: Tue, 16 Jul 2013 14:21:27 +0530
Message-ID: <CAKohponOEcwq4eAjwxHMM6puuqGmtJ4GpqqRHyEqvhXM+Yt6wQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] cpufreq: Store cpufreq policies in a list
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> @@ -2056,6 +2058,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>         subsys_interface_unregister(&cpufreq_interface);
>         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>
> +       list_del(&cpufreq_policy_list);

You can't delete the list this way... You must have passed the list
entry you wanted to delete. More precisely link from the struct
cpufreq_policy.

Over that, it shouldn't be done at the time of unregistering cpufreq
driver but as and when cpus are removed and _cpu_remove_dev
is called.
