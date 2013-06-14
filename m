Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3FNMh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:37:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37264 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab3FNMhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:37:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Fri, 14 Jun 2013 14:46:38 +0200
Message-ID: <1469773.K3KVgsTfzW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130613223740.GE32112@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <1645236.hTWQPUhyIx@vostro.rjw.lan> <20130613223740.GE32112@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 12:37:41 AM Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 12:15:36AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, June 13, 2013 11:40:08 PM Borislav Petkov wrote:
> 
> [ … ]
> 
> > > Not bad. However, exec_test and fork_test are kinda unexpected with such
> > > a high improvement percentage. Happen to have an explanation?
> > > 
> > > FWIW, if we don't find any serious perf/power regressions with
> > > this patch, I'd say it is worth applying even solely for the code
> > > simplification it brings.
> > 
> > May I take this as an ACK? ;-)
> > 
> > Well, that's my opinion too, actually.
> 
> I know - you told me and I like that aspect :-). And from the test
> results so far, the code simplification is maybe the most persuasive
> one. The slight improvements in perf/power are then the cherry on top.
> 
> Although, I'm not sure we're exhaustive with the benchmarks and we
> should maybe run a couple more. Although, judging by the results,
> generally no serious outliers should be expected (except exec_test and
> fork_test funsies above), which are actually positive outliers.
> 
> Judging by the code change, the only worry we should have, AFAIU, is
> any raise in power consumption due to spending longer periods in the
> intermediary P-states now and not going straight to the lowest P-state.
> But this compensates with improvement in runtime of the workloads.
> 
> Hmm, I dunno - I'm just thinking out loud here...

OK, so here's a deal.  After 3.10-rc1 goes out, I'll put this into linux-next
for 3.12, so that people have a few more weeks to complain.  If they don't,
it'll go into 3.12.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
