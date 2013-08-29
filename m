Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3H2UUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:20:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42920 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3H2UUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:20:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: Don't use smp_processor_id() in preemptible context
Date: Thu, 29 Aug 2013 22:31:19 +0200
Message-ID: <3563046.VrjExr8Wi1@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=VEiA11aaJPBi5NiAoq+GwTx2dkmpEa=DVE=zcuufGGA@mail.gmail.com>
References: <521E24CE.9090407@codeaurora.org> <1377725085-16798-1-git-send-email-sboyd@codeaurora.org> <CAKohpo=VEiA11aaJPBi5NiAoq+GwTx2dkmpEa=DVE=zcuufGGA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 29, 2013 09:50:22 AM Viresh Kumar wrote:
> On 29 August 2013 02:54, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > Workqueues are preemptible even if works are queued on them with
> > queue_work_on(). Let's use raw_smp_processor_id() here to silence
> > the warning.
> >
> > BUG: using smp_processor_id() in preemptible [00000000] code: kworker/3:2/674
> > caller is gov_queue_work+0x28/0xb0
> > CPU: 0 PID: 674 Comm: kworker/3:2 Tainted: G        W    3.10.0 #30
> > Workqueue: events od_dbs_timer
> > [<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)
> > [<c0109dec>] (show_stack+0x10/0x14) from [<c03885a4>] (debug_smp_processor_id+0xbc/0xf0)
> > [<c03885a4>] (debug_smp_processor_id+0xbc/0xf0) from [<c0635864>] (gov_queue_work+0x28/0xb0)
> > [<c0635864>] (gov_queue_work+0x28/0xb0) from [<c0635618>] (od_dbs_timer+0x108/0x134)
> > [<c0635618>] (od_dbs_timer+0x108/0x134) from [<c01aa8f8>] (process_one_work+0x25c/0x444)
> > [<c01aa8f8>] (process_one_work+0x25c/0x444) from [<c01aaf88>] (worker_thread+0x200/0x344)
> > [<c01aaf88>] (worker_thread+0x200/0x344) from [<c01b03bc>] (kthread+0xa0/0xb0)
> > [<c01b03bc>] (kthread+0xa0/0xb0) from [<c01061b8>] (ret_from_fork+0x14/0x3c)
> >
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  drivers/cpufreq/cpufreq_governor.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.12, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
