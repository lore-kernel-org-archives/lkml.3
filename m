Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3DLWny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:43:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57494 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3DLWnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:43:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
Date: Sat, 13 Apr 2013 00:51:39 +0200
Message-ID: <1923819.6Nb81T2TR8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUW+TB3q58bL+d=A355S4vtRhwMq8AV+tqjv6MgDtHRCaA@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com> <CA+icZUUsAqJ3kyCZivYeTpY7n=EDMv1UcC2VNwQro4h7NHDWag@mail.gmail.com> <CA+icZUW+TB3q58bL+d=A355S4vtRhwMq8AV+tqjv6MgDtHRCaA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 12, 2013 11:08:37 PM Sedat Dilek wrote:
> On Fri, Apr 12, 2013 at 6:27 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Fri, Apr 12, 2013 at 5:45 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >> On Fri, Apr 12, 2013 at 4:24 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>> On Fri, Apr 12, 2013 at 10:23 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >>>> On 10 April 2013 11:44, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>> I found this "[RFC PATCH] kbuild: Build linux-tools package with 'make
> >>>>> deb-pkg'" from February 2012.
> >>>>> Can't say what happened to it...
> >>>>
> >>>> Sedat,
> >>>>
> >>>> Sorry for being late. I am down with Fever and throat infection since few days.
> >>>> Still struggling with it..
> >>>>
> >>>> There are few things i tried. Firstly the tag: next-20130326 is bad as there are
> >>>> some bad commits in cpufreq core in it.
> >>>>
> >>>> I then tried latest linux-next/master on my Thinkpad (model name        : Intel(R)
> >>>> Core(TM) i7-2640M CPU @ 2.80GHz) and couldn't boot it up. My ubuntu
> >>>> just hanged.
> >>>>
> >>>> Then i tried Rafael's linux-next branch
> >>>>
> >>>> 079576f Merge branch 'pm-cpufreq-next' into linux-next
> >>>>
> >>>> And couldn't find any issues with it. I am easily able to remove/add cpus at
> >>>> runtime..
> >>>>
> >>>> Can you give this branch a try?
> >>>>
> >>>
> >>> OK, you seem to be well again, nice to hear.
> >>>
> >>> I was doing the whole week spring-cleaning in the apartment of my parents.
> >>> Now, I have some minutes for a compilation run.
> >>>
> >>> I guess "cpufreq: Call __cpufreq_governor() with correct policy->cpus
> >>> mask" could be the correct fix, but will try the GIT branch you have
> >>> mentioned.
> >>>
> >>> - Sedat -
> >>>
> >>> [1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=e4969ebac83fdea78d89c779331396728a4e6199
> >>>
> >>
> >> Both BROKEN here, specific pm-next commitid and pulling
> >> pm.git#linux-next into next-20130411 (see attached files).
> >>
> >> Is "cpufreq: convert cpufreq_driver to using RCU" the root cause of this all?
> >>
> >
> > [ CC Nathan ]
> >
> > NO, wrong assumption.
> >
> > 2013-04-12 18:04 Sedat Dilek        o [revert-cpufreq-rcu] Revert
> > "cpufreq: convert cpufreq_driver to using RCU"
> > 2013-04-12 18:04 Sedat Dilek        o Revert "cpufreq: Call
> > __cpufreq_governor() with correct policy->cpus mask"
> > 2013-04-11 23:24 Rafael J. Wysocki  M─┐ [pm-next-079576f] Merge branch
> > 'pm-cpufreq-next' into linux-next
> >
> > - Sedat -
> >
> >
> >> - Sedat -
> >>
> >> [1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=5800043b2488a1c4c6e859af860644d37419d58b
> >>
> >>>> --
> >>>> viresh
> 
> [ TO Dirk (Author of Intel pstate driver) ]
> 
> With CONFIG_X86_INTEL_PSTATE=n (unset) I do not see the call-trace!
> 
> My kernel-config and dmesg are attached.

You're seeing a trouble with a new driver, then, so that's not a regression.

Thanks for taking the time to debug this!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
