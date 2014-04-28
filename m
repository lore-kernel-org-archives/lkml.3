Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaD1U5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:57:40 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:33025 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaD1U5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:57:38 -0400
Date: Mon, 28 Apr 2014 23:57:34 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Cpufreq frequency serialization fixes
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
Message-ID: <alpine.SOC.1.00.1404282357170.13567@math.ut.ee>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
> commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
> The root-cause of this issue is the extra invocation of the
> cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
> longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
> drivers as well. This patchset fixes the issue in all the 3 drivers and also
> adds a debug infrastructure to catch such issues easily.
> 
> Patches 1-4 fix the regression in longhaul, powernow-k6 and powernow-k7
> drivers. (Patch 2 fixes a different bug in powernow-k6, and it is kept as a
> separate patch instead of merging it with patch 3, because I felt that it was
> a bit subtle and needed attention in a separate patch).
> 
> Patch 5 adds a debug infrastructure to the cpufreq core to catch such problems
> more easily in the future.
> 
> 
> Changes in v2:
> --------------
> 
> * Modified patch 1 to take error returns into account, as pointed out by
>   Viresh.
> * Added patch 2 to fix the existing issue in the powernow-k6 driver, pointed
>   out by Viresh.
> * Added patch 5 to introduce a debug infrastructure to catch such issues
>   easily.

This also works on my VIA EPIA.

-- 
Meelis Roos (mroos@linux.ee)
