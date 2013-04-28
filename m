Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3D1WOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 18:14:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48299 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab3D1WOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 18:14:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>, Nathan Zimmer <nzimmer@sgi.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next v8] cpufreq: convert the cpufreq_driver to use the rcu
Date: Mon, 29 Apr 2013 00:22:32 +0200
Message-ID: <3218775.0Qs2EbHdzR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponJ3s_cpGmHv8MtqB0SCDXi_16=QYocLxOY-ZeLtj-5uA@mail.gmail.com>
References: <515C5AB6.5090109@sgi.com> <1365087205-8708-1-git-send-email-nzimmer@sgi.com> <CAKohponJ3s_cpGmHv8MtqB0SCDXi_16=QYocLxOY-ZeLtj-5uA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 09:57:19 PM Viresh Kumar wrote:
> On 4 April 2013 20:23, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > We eventually would like to remove the rwlock cpufreq_driver_lock or convert
> > it back to a spinlock and protect the read sections with RCU.  The first step in
> > that is moving the cpufreq_driver to use the rcu.
> > I don't see an easy wasy to protect the cpufreq_cpu_data structure with the
> > RCU, so I am leaving it with the rwlock for now since under certain configs
> > __cpufreq_cpu_get is hot spot with 256+ cores.
> >
> > v5: Go a different way and split up the lock and use the rcu
> > v6: use bools instead of checking function pointers
> >     covert the cpufreq_data_lock to a rwlock
> > v7: Rebase to use the already accepted half
> > v8: Correct have_governor_per_policy
> >     Reviewed location of rcu_read_(un)lock in several spots
> 
> Sorry for long delay or too many versions of this patch :)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Unfortunately, I had to revert this one, because it is obviously buggy.  Why?
Because it adds rcu_read_lock()/rcu_read_unlock() around sysfs_create_file()
which may sleep due to a GFP_KERNEL memory allocation.  Sorry for failing to
notice that earlier.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
