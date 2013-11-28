Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3K1M5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:57:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59702 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757898Ab3K1M5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:57:10 -0500
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
Date: Thu, 28 Nov 2013 14:09:59 +0100
Message-ID: <14305907.pSqK27Oikr@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohponPOFP3pxZYngZcFneBMNozNkCyB1Yevj4801TqfAxHbw@mail.gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org> <5408313.YdNvR1b3g5@vostro.rjw.lan> <CAKohponPOFP3pxZYngZcFneBMNozNkCyB1Yevj4801TqfAxHbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 08:50:20 AM Viresh Kumar wrote:
> On 28 November 2013 01:51, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > I have a concern that on some systems you can't really say what frequency
> > you're running at the moment, however.
> 
> Which ones? I know ACPI tries to play smart by handling the frequency stuff
> itself by marking CPUs not-related to each other for the kernel where they
> might actually be sharing clock line... But probably in these cases as well,
> atleast the cpufreq core should believe that it is running on a valid frequency
> even if actual hardware is running at something different..
> 
> Any other platforms you are aware of that implement ->target/target_index
> and where we can't say what freq are they running at?

acpi-cpufreq is one at least.

Anyway, this isn't about ACPI or anything like that, but hardware.  Generally
speaking, on modern Intel hardware the processor itself chooses the frequency
to run at and it may do that behind your back.  Moreover, it can choose a
frequency different from the one you asked for.  And it won't choose one that
it can't run at for that matter. :-)

Overall, I don't believe that the problem you're trying to address is relevant
for any non-exotic x86 hardware.

> > So there should be a flag for
> > drivers indicating whether or not frequencies (or operation points in
> > general) are directly testable and the check should only be done for
> > the drivers with the flag set.
> 
> Probably a flag with properties exactly opposite to what you mentioned,
> so that we don't need to modify most of the drivers..

That would work too if you prefer it.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
