Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaLQR2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:28:46 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54636 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:28:44 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
Date: Wed, 17 Dec 2014 09:28:42 -0800
Message-ID: <3741028.CtOSUWyiaT@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-40-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org> <1418771379-24369-4-git-send-email-dtor@chromium.org> <CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2014 10:06:17 AM Viresh Kumar wrote:
> On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
> > A lot of callers are missing the fact that dev_pm_opp_get_opp_count
> > needs to be called under RCU lock. Given that RCU locks can safely be
> > nested, instead of providing *_locked() API, let's take RCU lock inside
> 
> Hmm, I asked for a *_locked() API because many users of
> dev_pm_opp_get_opp_count() are already calling it from rcu read side
> critical sections.
> 
> Now, there are two questions:
> - Can rcu-read side critical sections be nested ?
> 
> Yes, this is what the comment over rcu_read_lock() says
> 
>  * RCU read-side critical sections may be nested.  Any deferred actions
>  * will be deferred until the outermost RCU read-side critical section
>  * completes.
> 
> - Would it be better to drop these double rcu_read_locks() ? i.e. either
> get a *_locked() API or fix the callers of dev_pm_opp_get_opp_count().
> 
> @Paul: What do you say ?
>

FWIW the change is a stop-gap; I hope we'll get away from using 
dev_pm_opp_get_opp_count() in cpufreq drivers and then we can revert the 
change. I just did not want to touch cpufreq drivers unless necessary.

Thanks,
Dmitry
