Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaGKQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:57:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34258 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaGKQ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:57:14 -0400
Date: Fri, 11 Jul 2014 18:57:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Eliminate the deadband effect
Message-ID: <20140711165710.GA18033@amd.pavel.ucw.cz>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
 <1404147574-17422-3-git-send-email-stratosk@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404147574-17422-3-git-send-email-stratosk@semaphore.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Tested on Intel i7-3770 CPU @ 3.40GHz and on ARM quad core 1500MHz Krait
> (Android smartphone).
> Benchmarks on Intel i7 shows a performance improvement on low and medium
> work loads with lower power consumption. Specifics:
> 
> Phoronix Linux Kernel Compilation 3.1:
> Time: -0.40%, energy: -0.07%
> Phoronix Apache:
> Time: -4.98%, energy: -2.35%
> Phoronix FFMPEG:
> Time: -6.29%, energy: -4.02%

Hmm. Intel i7 should be race-to-idle machine. So basically rule like
if (load > 0) go to max frequency else go to lowest frequency would do
the right thing in your test, right?

So... should we do that, or do we need better benchmark?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
