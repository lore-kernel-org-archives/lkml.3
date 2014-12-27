Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaL0UPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:15:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56208 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751562AbaL0UPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:15:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nishanth Menon <nm@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Stop BUGing the system
Date: Sat, 27 Dec 2014 21:37:21 +0100
Message-ID: <7827225.rRPiS1j5HK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <549AD65D.4010000@ti.com>
References: <1418831495-26958-1-git-send-email-nm@ti.com> <3146996.LXve8MJFme@vostro.rjw.lan> <549AD65D.4010000@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 24, 2014 09:06:05 AM Nishanth Menon wrote:
> On 12/18/2014 08:08 PM, Rafael J. Wysocki wrote:
> > On Friday, December 19, 2014 07:11:19 AM Viresh Kumar wrote:
> >> On 18 December 2014 at 20:19, Nishanth Menon <nm@ti.com> wrote:
> >>> I can add "could be unstable" -> the point being there can be psuedo
> >>> errors reported in the system - example - clock framework bugs. Dont
> >>> just stop the boot. example: what if cpufreq was a driver module - it
> >>> would not have rescued the system because cpufreq had'nt detected the
> >>> logic - if we are going to force this on the system, we should probably
> >>> not do this in cpufreq code, instead should be somewhere generic.
> >>>
> >>> While I do empathise (and had infact advocated in the past) of not
> >>> favouring system attempting to continue at an invalid configuration and
> >>> our attempt to rescue has failed - given that we cannot provide a
> >>> consistent behavior (it is not a core system behavior) and potential of
> >>> a false-postive (example clk framework or underlying bug), it should be
> >>> good enough to "enhance" WARN to be "severe sounding enough" to
> >>> flag it for developer and continue while keeping the system alive as
> >>> much as possible.
> >>
> >> There is no way out for the kernel to know if its a false positive or a real
> >> bug. And in the worst case, it can screw up a platform completely.
> >>
> >> I am still not sure if changing it to a WARN would be good idea.
> >>
> >> @Rafael: Thoughts ?
> > 
> > I'm a bit divided here.  On the one hand I don't like BUG_ON() as a rule and it
> > is used in too many places where it doesn't have to be used.
> > 
> > On the other hand, in this particular case, I'm not sure if allowing the system
> > to run without cpufreq when it might rely on it for CPU cooling, for one example,
> > is a good idea.
> 
> but then, CPUFReq is not a mandatory feature - we could as well do the
> same with CPU_FREQ disabled.

Some platforms pretty much require CPU_FREQ and will always have it set, but
with the $subject patch they may end up not using it.

So this isn't a valid argument to me, sorry.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
