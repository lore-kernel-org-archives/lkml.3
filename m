Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaIHX4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:56:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56731 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754610AbaIHX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:56:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Shreyas Prabhu <shreyas@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 0/2] cpufreq/powernv: Set core pstate to a minimum just before hotplugging it out
Date: Tue, 09 Sep 2014 02:16:03 +0200
Message-ID: <7863288.1rO87QF8NW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpo=chEW_TtXWCHa3OEwrqU25TPBES4icjMVxL6nezrf8+w@mail.gmail.com>
References: <20140905073812.3629.29175.stgit@preeti.in.ibm.com> <CAKohpo=chEW_TtXWCHa3OEwrqU25TPBES4icjMVxL6nezrf8+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 05, 2014 01:11:22 PM Viresh Kumar wrote:
> On 5 September 2014 13:09, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> > Today cpus go to winkle when they are offlined. Since it is the deepest
> > idle state that we have, it is expected to save good amount of power as compared
> > to online state, where cores can enter nap/fastsleep only which are
> > shallower idle states.
> > However we observed no powersavings with winkle as compared to nap/fastsleep
> > and traced the problem to the pstate of the core being kept at a high even
> > when the core is offline. This can keep the socket pstate high, thus burning
> > power unnecessarily. This patchset fixes this issue.
> >
> > Changes in V2: Changed smp_call_function_any() to smp_call_function_single() in Patch[2/2]
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

I've queued up the two patches for 3.18, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
