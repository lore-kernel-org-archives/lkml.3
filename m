Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3FJV5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:57:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:59995 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857Ab3FJV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:57:30 -0400
Message-ID: <51B64BC6.6040400@semaphore.gr>
Date: Tue, 11 Jun 2013 00:57:26 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <20130609162653.GA5004@pd.tnic> <51B4C497.2030308@semaphore.gr> <7661669.NhG4BEI8zO@vostro.rjw.lan>
In-Reply-To: <7661669.NhG4BEI8zO@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 11:58 PM, Rafael J. Wysocki wrote:
> Well, this means that your changes may hurt performance if the load comes and
> goes in spikes, which is not so good.  The fact that they cause less energy to
> be used at the same time kind of balance that, though.  [After all, we're
> talking about the ondemand governor which should be used if the user wants to
> sacrifice some performance for energy savings.]
> 
> It would be interesting to see if the picture changes for different time
> intervals in your test program (e.g. loop duration that is not a multiple of
> sampling_rate and sleep times different from 5000 us) to rule out any random
> coincidences.
> 
> Can you possibly prepare a graph showing both the execution time and energy
> consumption for several different loop durations in your program (let's keep
> the 5000 us sleep for now), including multiples of sampling_rate as well as
> some other durations?

Hi,

I tested different loop durations with my program from 1,000us to 1,000,000us.
The logic is almost the same with the previous test:

1) Use a 'for' loop to a period T (~ 1000-1000000us)
2) sleep for 5000us
3) Repeat steps 1-2, 50 times.
4) sleep for 1s
5) Repeat 1-4, 5 times.

The results:
https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddE13ZUtYdGs2dUVRdG00bVRVT3JScWc&usp=sharing

Sheet1 (ProcessX1) includes the results from the test program running
as single copy. The second one (ProcessX4) includes the results from the test
program running it in 4 copies in parallel (using a bash script that waits
the end of execution).

Graphs show the difference(%) in total execution time and total energy without
and with the patch.
Negative values mean that the test *with* the patch had better performance or
used less energy.

Test shows that below sampling rate (10000us in my config), ondemand with this
patch behaves better (both in performance and consumption).
Though, in this test, for loads with 10000us < duration <= 200000us ondemand
behaves better without the patch.   

Thanks,
Stratos
