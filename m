Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaGKSeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:34:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36891 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaGKSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:34:17 -0400
Date: Fri, 11 Jul 2014 20:34:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Eliminate the deadband effect
Message-ID: <20140711183414.GA18951@amd.pavel.ucw.cz>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
 <1404147574-17422-3-git-send-email-stratosk@semaphore.gr>
 <20140711165710.GA18033@amd.pavel.ucw.cz>
 <53C01F15.2090702@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C01F15.2090702@semaphore.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-07-11 20:29:57, Stratos Karafotis wrote:
> Hi Pavel!
> 
> On 11/07/2014 07:57 μμ, Pavel Machek wrote:
> > Hi!
> > 
> >> Tested on Intel i7-3770 CPU @ 3.40GHz and on ARM quad core 1500MHz Krait
> >> (Android smartphone).
> >> Benchmarks on Intel i7 shows a performance improvement on low and medium
> >> work loads with lower power consumption. Specifics:
> >>
> >> Phoronix Linux Kernel Compilation 3.1:
> >> Time: -0.40%, energy: -0.07%
> >> Phoronix Apache:
> >> Time: -4.98%, energy: -2.35%
> >> Phoronix FFMPEG:
> >> Time: -6.29%, energy: -4.02%
> > 
> > Hmm. Intel i7 should be race-to-idle machine. So basically rule like
> > if (load > 0) go to max frequency else go to lowest frequency would do
> > the right thing in your test, right?
> 
> I don't think that "if (load > 0) go to max" will work even on i7.
> For low load this will have impact on energy consumption.

Are you sure? CPU frequency should not matter on idle CPU.

(Can you try to modify your code and rerun for example the apache
test?)

> > So... should we do that, or do we need better benchmark?
> 
> I'm sorry. I'm not sure I understood exactly what do you mean by "better
> benchmark".

I believe that any increase of frequency in frequency will make the
benchmarks you qouted better (on i7). Actually, you can probably just
select performance governor...?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
