Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab3K1OAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:00:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53696 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757373Ab3K1OAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:00:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Thu, 28 Nov 2013 15:12:57 +0100
Message-ID: <2065797.S0ijuuXCoe@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokyY0ueNXBQn+Vt5A9V65_ko7D5R=iruUzi6cD9YuXOig@mail.gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org> <14305907.pSqK27Oikr@vostro.rjw.lan> <CAKohpokyY0ueNXBQn+Vt5A9V65_ko7D5R=iruUzi6cD9YuXOig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 07:11:17 PM Viresh Kumar wrote:
> On 28 November 2013 18:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > acpi-cpufreq is one at least.
> >
> > Anyway, this isn't about ACPI or anything like that, but hardware.  Generally
> > speaking, on modern Intel hardware the processor itself chooses the frequency
> > to run at and it may do that behind your back.  Moreover, it can choose a
> > frequency different from the one you asked for.  And it won't choose one that
> > it can't run at for that matter. :-)
> >
> > Overall, I don't believe that the problem you're trying to address is relevant
> > for any non-exotic x86 hardware.
> 
> Okay.. So wouldn't it be better that we add this special flag only when we
> face a real problem? Otherwise this flag might stay unused for long time
> and then we might end up removing it..
> 
> >> > So there should be a flag for
> >> > drivers indicating whether or not frequencies (or operation points in
> >> > general) are directly testable and the check should only be done for
> >> > the drivers with the flag set.
> >>
> >> Probably a flag with properties exactly opposite to what you mentioned,
> >> so that we don't need to modify most of the drivers..
> >
> > That would work too if you prefer it.
> 
> In case we need this flag, what should we name it?
> ALLOW_UNKNOWN_FREQ ??

SKIP_INITIAL_FREQUENCY_CHECK ?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
