Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3A1Ko4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:44:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:63213 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab3A1Kox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:44:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+25aIyHh22ZcCIu/JWsKoXpNSlkD168dKstN1F2u
	9l//jVWLL48sYv
Message-ID: <1359369884.5783.117.camel@marge.simpson.net>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 11:44:44 +0100
In-Reply-To: <20130128095501.GB6109@pd.tnic>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
	 <1359301903.5805.11.camel@marge.simpson.net>
	 <1359350266.5783.39.camel@marge.simpson.net>
	 <20130128095501.GB6109@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 10:55 +0100, Borislav Petkov wrote: 
> On Mon, Jan 28, 2013 at 06:17:46AM +0100, Mike Galbraith wrote:
> > Zzzt.  Wish I could turn turbo thingy off.
> 
> Try setting /sys/devices/system/cpu/cpufreq/boost to 0.

How convenient (test) works too.

So much for turbo boost theory.  Nothing changed until I turned load
balancing off at NODE.  High end went to hell (gee), but low end... 
  
Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   performance-no-node-load_balance Jan 28 11:20:12 2013

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
1       436.3           100     13.9    3.9     7.2714
5       2637.1          99      11.5    7.3     8.7903
10      5415.5          99      11.2    11.3    9.0259
20      10603.7         99      11.4    24.8    8.8364
40      20066.2         99      12.1    40.5    8.3609
80      35079.6         99      13.8    75.5    7.3082
160     55884.7         98      17.3    145.6   5.8213
320     79345.3         98      24.4    287.4   4.1326
640     100294.8        98      38.7    570.9   2.6118  
1280    115998.2        97      66.9    1132.8  1.5104  
2560    125820.0        97      123.3   2256.6  0.8191

