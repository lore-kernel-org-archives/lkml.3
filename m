Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3K0OOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:14:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57637 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755257Ab3K0OOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:14:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
Date: Wed, 27 Nov 2013 15:26:49 +0100
Message-ID: <1569441.L2JJETg4Jp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=4ZdDybsm6oz0-GjCyP2c8MGvV9uZG8n+Cv2xGKcmeDQ@mail.gmail.com>
References: <cover.1385118255.git.viresh.kumar@linaro.org> <9179214.Tbesu8t5px@vostro.rjw.lan> <CAKohpo=4ZdDybsm6oz0-GjCyP2c8MGvV9uZG8n+Cv2xGKcmeDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 08:26:00 AM Viresh Kumar wrote:
> On 27 November 2013 01:48, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, November 26, 2013 08:39:02 PM Pavel Machek wrote:
> >> So... we freeze frequencies in whatever state they are, yes?
> 
> Better go through the V3 of this patchset:
> 
> https://lkml.org/lkml/2013/11/25/838
> 
> We are giving drivers and opportunity to set core to whatever frequency they
> want before suspending.
> 
> > Yes.  The idea was to do that after suspending devices in which case it wouldn't
> > matter so much.  But Viresh always has to complicate things.
> 
> :)
> 
> Its complicated by the kind of designs we have for our hardware. We tried the
> noirq callbacks and it worked atleast for Nishanth, who reported the problem
> initially. But the problem started when drivers wanted to change their
> frequencies before suspending and that can't happen in noirq place..

This way you end up with a fix that may introduce other issues.  Which is kind
of fine before a merge window, but not so much after one.  So at this point it's
better to fix things that may be fixed without introducing those other issues
*first* and then go for a more intrusive change that will cover more cases.

> I had another idea but then left it thinking that it might be even more
> complicated :)
> 
> What about both dpm_suspend_noirq and dpm_suspend callbacks. Drivers
> will change freq in dpm_suspend_noirq and dpm_suspend will stop governors?
> 
> But the question is can governors try another frequency at that time?
> i.e. override whatever is configured by drivers?
> 
> >> Should we go to some specific frequency?
> >
> > If that is done where it is done, yes, we should.
> 
> You meant dpm_suspend() here, right?

Yes.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
