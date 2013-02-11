Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3BKT3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:29:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37253 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3BKT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:29:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Mon, 11 Feb 2013 20:36:17 +0100
Message-ID: <1953281.cgEiiBGo0f@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <74F10842A85F514CA8D8C487E74474BB2D30DC9E@P-EXMB1-DC21.corp.sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com> <16615226.2vj4EkkIZJ@vostro.rjw.lan> <74F10842A85F514CA8D8C487E74474BB2D30DC9E@P-EXMB1-DC21.corp.sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 05:13:30 PM Nathan Zimmer wrote:
> There are some spots that I need to give a much deeper review, cpufreq_register_driver for example.
> 
> But I believe 
> > @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
> >  {
> >       if (!sysfs)
> >               kobject_put(&data->kobj);
> > -     module_put(cpufreq_driver->owner);
> > +     module_put(rcu_dereference(cpufreq_driver)->owner);
> >  }
> would be ok.  In the documentation whatisRCU.txt they give a very similar example.

Well, the very same document states the following:

        Note that the value returned by rcu_dereference() is valid
        only within the enclosing RCU read-side critical section.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
