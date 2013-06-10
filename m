Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3FJXPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:15:20 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33597 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3FJXPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:15:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Tue, 11 Jun 2013 01:24:25 +0200
Message-ID: <16929930.1G36b4NkSe@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51B64BC6.6040400@semaphore.gr>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <7661669.NhG4BEI8zO@vostro.rjw.lan> <51B64BC6.6040400@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 12:57:26 AM Stratos Karafotis wrote:
> On 06/09/2013 11:58 PM, Rafael J. Wysocki wrote:
> > Well, this means that your changes may hurt performance if the load comes and
> > goes in spikes, which is not so good.  The fact that they cause less energy to
> > be used at the same time kind of balance that, though.  [After all, we're
> > talking about the ondemand governor which should be used if the user wants to
> > sacrifice some performance for energy savings.]
> > 
> > It would be interesting to see if the picture changes for different time
> > intervals in your test program (e.g. loop duration that is not a multiple of
> > sampling_rate and sleep times different from 5000 us) to rule out any random
> > coincidences.
> > 
> > Can you possibly prepare a graph showing both the execution time and energy
> > consumption for several different loop durations in your program (let's keep
> > the 5000 us sleep for now), including multiples of sampling_rate as well as
> > some other durations?
> 
> Hi,
> 
> I tested different loop durations with my program from 1,000us to 1,000,000us.
> The logic is almost the same with the previous test:
> 
> 1) Use a 'for' loop to a period T (~ 1000-1000000us)
> 2) sleep for 5000us
> 3) Repeat steps 1-2, 50 times.
> 4) sleep for 1s
> 5) Repeat 1-4, 5 times.
> 
> The results:
> https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddE13ZUtYdGs2dUVRdG00bVRVT3JScWc&usp=sharing
> 
> Sheet1 (ProcessX1) includes the results from the test program running
> as single copy. The second one (ProcessX4) includes the results from the test
> program running it in 4 copies in parallel (using a bash script that waits
> the end of execution).
> 
> Graphs show the difference(%) in total execution time and total energy without
> and with the patch.
> Negative values mean that the test *with* the patch had better performance or
> used less energy.
> 
> Test shows that below sampling rate (10000us in my config), ondemand with this
> patch behaves better (both in performance and consumption).
> Though, in this test, for loads with 10000us < duration <= 200000us ondemand
> behaves better without the patch.

Thanks for these results!

Well, I'd say that this doesn't look rosy any more, so the jury is still out.

We need more testing with different workloads and on different hardware.  I'll
try to arrange something to that end.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
