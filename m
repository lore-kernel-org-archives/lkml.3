Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab3GZKOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:14:33 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41490 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3GZKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <1374770011-22171-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-2-git-send-email-l.majewski@samsung.com>
Date: Fri, 26 Jul 2013 15:44:29 +0530
Message-ID: <CAKohpoktwZUvs2ap7wk1tudVsiKjbhFkoM5=+AaFZP=+73fEyg@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] cpufreq: Store cpufreq policies in a list
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Policies available in a cpufreq framework are now linked together. They are
> accessible via cpufreq_policy_list defined at cpufreq core.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Looks good but would have been better if you could have moved
existing code to use this infrastructure..

For example, this code in __cpufreq_add_dev()

#ifdef CONFIG_HOTPLUG_CPU
	/* Check if this cpu was hot-unplugged earlier and has siblings */
	read_lock_irqsave(&cpufreq_driver_lock, flags);
	for_each_online_cpu(sibling) {

         ---

	}
	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
#endif
