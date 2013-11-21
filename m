Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3KUVbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:31:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56083 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754795Ab3KUVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:31:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across system suspend/resume
Date: Thu, 21 Nov 2013 22:43:45 +0100
Message-ID: <1599716.5y7kNnD1dc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohponphVhZ3T1HD2AfhPBUn9SfQyrqdbvW3bEJFzRdKF2i0Q@mail.gmail.com>
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan> <2383693.rhJDd9X40m@vostro.rjw.lan> <CAKohponphVhZ3T1HD2AfhPBUn9SfQyrqdbvW3bEJFzRdKF2i0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 09:24:02 PM Viresh Kumar wrote:
> On 21 November 2013 20:13, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> -     if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
> >
> > The inner parens are not necessary.
> >
> >> -                     ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> >> +     if ((event == CPUFREQ_GOV_POLICY_INIT) && ret) {
> >
> > Same here.
> >
> >> +             module_put(policy->governor->owner);
> >> +             if (ret == -EALREADY)
> >> +                     return 0;
> >> +     } else if ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret) {
> >
> > Same here.
> 
> Logically, yes you are correct. But probably its better for readability to
> get these even if you know precedence is going to take care of our
> expression..

Are you serious?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
