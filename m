Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaFILQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:16:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62264 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932253AbaFILQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:16:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, pavel@ucw.cz
Subject: Re: [PATCH Resend] cpufreq: governor: remove copy_prev_load from 'struct cpu_dbs_common_info'
Date: Mon, 09 Jun 2014 13:33:52 +0200
Message-ID: <11428356.dfoumlK3pv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53957A30.4030003@linux.vnet.ibm.com>
References: <c7add1b66e706fc52c493f765d0ddfc8c83f3b2e.1402303829.git.viresh.kumar@linaro.org> <53957A30.4030003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 09, 2014 02:41:12 PM Srivatsa S. Bhat wrote:
> On 06/09/2014 02:21 PM, Viresh Kumar wrote:
> > 'copy_prev_load' was recently added by commit: 18b46ab (cpufreq: governor: Be
> > friendly towards latency-sensitive bursty workloads).
> > 
> > It actually is a bit redundant as we also have 'prev_load' which can store any
> > integer value and can be used instead of 'copy_prev_load' by setting it zero.
> > 
> > True load can also turn out to be zero during long idle intervals (and hence the
> > actual value of 'prev_load' and the overloaded value can clash). However this is
> > not a problem because, if the true load was really zero in the previous
> > interval, it makes sense to evaluate the load afresh for the current interval
> > rather than copying the previous load.
> > 
> > So, drop 'copy_prev_load' and use 'prev_load' instead.
> > 
> > Update comments as well to make it more clear.
> > 
> > There is another change here which was probably missed by Srivatsa during the
> > last version of updates he made. The unlikely in the 'if' statement was covering
> > only half of the condition and the whole line should actually come under it.
> > 
> > Also checkpatch is made more silent as it was reporting this (--strict option):
> > 
> > CHECK: Alignment should match open parenthesis
> > +		if (unlikely(wall_time > (2 * sampling_rate) &&
> > +						j_cdbs->prev_load)) {
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > Resend: Updated comments/logs as suggested by Srivatsa.
> > 
> 
> Looks good!
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to bleeding-edge, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
