Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaIIXWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:22:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49772 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIIXWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:22:32 -0400
Date: Tue, 9 Sep 2014 16:22:29 -0700
From: Anup Chenthamarakshan <anupc@chromium.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
Message-ID: <20140909232229.GA28142@google.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
 <540F1981.1090805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F1981.1090805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:15:13AM -0700, Dirk Brandewie wrote:
> On 09/08/2014 05:10 PM, Anup Chenthamarakshan wrote:
> > Exported stats appear in
> > <sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
> > 
> > ## CPU 0
> > 400000 3647
> > 500000 24342
> > 600000 144150
> > 700000 202469
> > ## CPU 1
> > 400000 4813
> > 500000 22628
> > 600000 149564
> > 700000 211885
> > 800000 173890
> > 
> > Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>
> 
> What is this information being used for?

I'm using P-state residency information in power consumption tests to calculate
proportion of time spent in each P-state across all processors (one global set
of percentages, corresponding to each P-state). This is used to validate new
changes from the power perspective. Essentially, sanity checks to flag changes
with large difference in P-state residency.

So far, we've been using the data exported by acpi-cpufreq to track this.

> 
> Tracking the current P state request for each core is only part of the 
> story.  The processor aggregates the requests from all cores and then decides
> what frequency the package will run at, this evaluation happens at ~1ms time
> frame.  If a core is idle then it loses its vote for that package frequency will
> be and its frequency will be zero even though it may have been requesting
> a high P state when it went idle.  Tracking the residency of the requested
> P state doesn't provide much useful information other than ensuring the the 
> requests are changing over time IMHO.

This is exactly why we're trying to track it.

> 
> This interface will not be supportable with upcoming processors using
> hardware P states as documented in volume 3 of the current SDM Section 14.4
> http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
> The OS will have no way of knowing what the P state requests are for a
> given core are.

Will there be any means to determine the proportion of time spent in different
HWP-states when HWP gets enabled (maybe at a package level)?
