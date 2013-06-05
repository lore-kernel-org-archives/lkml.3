Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3FEM2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:28:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58355 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FEM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:28:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: prevent 'policy->cpus' become offline in __gov_queue_work()
Date: Wed, 05 Jun 2013 14:37:50 +0200
Message-ID: <1862476.P5VBB45STK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51AEFDC4.8070801@linux.vnet.ibm.com>
References: <51AEFBA1.302@linux.vnet.ibm.com> <CAKohpom571kXwLVPzmAb1n16EuHwyOaiM3khXkjQZQixGCpX8Q@mail.gmail.com> <51AEFDC4.8070801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 05, 2013 04:58:44 PM Michael Wang wrote:
> Hi, Viresh
> 
> On 06/05/2013 04:53 PM, Viresh Kumar wrote:
> [snip]
> >> It was caused by the policy->cpus changed during the process of
> >> __gov_queue_work(), in other word, cpu offline happened.
> >>
> >> This patch will use get/put_online_cpus() to prevent the offline
> >> happen inside __gov_queue_work(), after applied the patch, the
> >> warning is gone as Jiri tested:
> >>
> >>         Link: https://lkml.org/lkml/2013/6/5/88
> >>
> >> CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> >> CC: Viresh Kumar <viresh.kumar@linaro.org>
> >> Reported-by: Borislav Petkov <bp@alien8.de>
> >> Reported-by: Jiri Kosina <jkosina@suse.cz>
> >> Tested-by: Jiri Kosina <jkosina@suse.cz>
> >> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> >> ---
> >>  drivers/cpufreq/cpufreq_governor.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Thanks for your ack :)

Queued up for 3.10.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
