Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013Ab3DDQ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:27:23 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55035 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762913Ab3DDQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <1365087205-8708-1-git-send-email-nzimmer@sgi.com>
References: <515C5AB6.5090109@sgi.com>
	<1365087205-8708-1-git-send-email-nzimmer@sgi.com>
Date: Thu, 4 Apr 2013 21:57:19 +0530
Message-ID: <CAKohponJ3s_cpGmHv8MtqB0SCDXi_16=QYocLxOY-ZeLtj-5uA@mail.gmail.com>
Subject: Re: [PATCH linux-next v8] cpufreq: convert the cpufreq_driver to use
 the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2013 20:23, Nathan Zimmer <nzimmer@sgi.com> wrote:
> We eventually would like to remove the rwlock cpufreq_driver_lock or convert
> it back to a spinlock and protect the read sections with RCU.  The first step in
> that is moving the cpufreq_driver to use the rcu.
> I don't see an easy wasy to protect the cpufreq_cpu_data structure with the
> RCU, so I am leaving it with the rwlock for now since under certain configs
> __cpufreq_cpu_get is hot spot with 256+ cores.
>
> v5: Go a different way and split up the lock and use the rcu
> v6: use bools instead of checking function pointers
>     covert the cpufreq_data_lock to a rwlock
> v7: Rebase to use the already accepted half
> v8: Correct have_governor_per_policy
>     Reviewed location of rcu_read_(un)lock in several spots

Sorry for long delay or too many versions of this patch :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
