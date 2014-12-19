Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaLSBqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:46:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61453 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253AbaLSBqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:46:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Kevin Hilman <khilman@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Stop BUGing the system
Date: Fri, 19 Dec 2014 03:08:32 +0100
Message-ID: <3146996.LXve8MJFme@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponxz0=n5g9uBOt=JqBMdtdi9mnsrh34emxZDO=PJikVaw@mail.gmail.com>
References: <1418831495-26958-1-git-send-email-nm@ti.com> <20141218144915.GA29004@kahuna> <CAKohponxz0=n5g9uBOt=JqBMdtdi9mnsrh34emxZDO=PJikVaw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 19, 2014 07:11:19 AM Viresh Kumar wrote:
> On 18 December 2014 at 20:19, Nishanth Menon <nm@ti.com> wrote:
> > I can add "could be unstable" -> the point being there can be psuedo
> > errors reported in the system - example - clock framework bugs. Dont
> > just stop the boot. example: what if cpufreq was a driver module - it
> > would not have rescued the system because cpufreq had'nt detected the
> > logic - if we are going to force this on the system, we should probably
> > not do this in cpufreq code, instead should be somewhere generic.
> >
> > While I do empathise (and had infact advocated in the past) of not
> > favouring system attempting to continue at an invalid configuration and
> > our attempt to rescue has failed - given that we cannot provide a
> > consistent behavior (it is not a core system behavior) and potential of
> > a false-postive (example clk framework or underlying bug), it should be
> > good enough to "enhance" WARN to be "severe sounding enough" to
> > flag it for developer and continue while keeping the system alive as
> > much as possible.
> 
> There is no way out for the kernel to know if its a false positive or a real
> bug. And in the worst case, it can screw up a platform completely.
> 
> I am still not sure if changing it to a WARN would be good idea.
> 
> @Rafael: Thoughts ?

I'm a bit divided here.  On the one hand I don't like BUG_ON() as a rule and it
is used in too many places where it doesn't have to be used.

On the other hand, in this particular case, I'm not sure if allowing the system
to run without cpufreq when it might rely on it for CPU cooling, for one example,
is a good idea.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
