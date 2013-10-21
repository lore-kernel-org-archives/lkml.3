Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3JUWfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:35:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63715 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752837Ab3JUWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:35:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "open list:CPU FREQUENCY DRI..." <cpufreq@vger.kernel.org>,
        "open list:CPU FREQUENCY DRI..." <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: fix possible integer overflow
Date: Tue, 22 Oct 2013 00:47:18 +0200
Message-ID: <1734089.XZ0ga7sQd1@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52654EA6.6020805@gmail.com>
References: <1382239876-12688-1-git-send-email-geyslan@gmail.com> <52654EA6.6020805@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 21, 2013 08:56:22 AM Dirk Brandewie wrote:
> On 10/19/2013 08:31 PM, Geyslan G. Bem wrote:
> > The expression 'pstate << 8' is evaluated using 32-bit arithmetic while
> > 'val' expects an expression of type u64.
> >
> > Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Actually, isn't (pstate << 8) guaranteed not to overflow?

> > ---
> >   drivers/cpufreq/intel_pstate.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index badf620..43446b5 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -395,7 +395,7 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
> >   	trace_cpu_frequency(pstate * 100000, cpu->cpu);
> >
> >   	cpu->pstate.current_pstate = pstate;
> > -	val = pstate << 8;
> > +	val = (u64)pstate << 8;
> >   	if (limits.no_turbo)
> >   		val |= (u64)1 << 32;
> >
> >
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
