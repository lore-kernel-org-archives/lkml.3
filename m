Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3FMWhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:37:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab3FMWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:37:46 -0400
Date: Fri, 14 Jun 2013 00:37:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130613223740.GE32112@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <51BA380A.1040009@semaphore.gr>
 <20130613214007.GA32127@pd.tnic>
 <1645236.hTWQPUhyIx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1645236.hTWQPUhyIx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:15:36AM +0200, Rafael J. Wysocki wrote:
> On Thursday, June 13, 2013 11:40:08 PM Borislav Petkov wrote:

[ … ]

> > Not bad. However, exec_test and fork_test are kinda unexpected with such
> > a high improvement percentage. Happen to have an explanation?
> > 
> > FWIW, if we don't find any serious perf/power regressions with
> > this patch, I'd say it is worth applying even solely for the code
> > simplification it brings.
> 
> May I take this as an ACK? ;-)
> 
> Well, that's my opinion too, actually.

I know - you told me and I like that aspect :-). And from the test
results so far, the code simplification is maybe the most persuasive
one. The slight improvements in perf/power are then the cherry on top.

Although, I'm not sure we're exhaustive with the benchmarks and we
should maybe run a couple more. Although, judging by the results,
generally no serious outliers should be expected (except exec_test and
fork_test funsies above), which are actually positive outliers.

Judging by the code change, the only worry we should have, AFAIU, is
any raise in power consumption due to spending longer periods in the
intermediary P-states now and not going straight to the lowest P-state.
But this compensates with improvement in runtime of the workloads.

Hmm, I dunno - I'm just thinking out loud here...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
