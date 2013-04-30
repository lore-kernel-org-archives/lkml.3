Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab3D3J4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:56:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916Ab3D3J4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:56:38 -0400
Message-ID: <1367315763.4616.93.camel@marge.simpson.net>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 30 Apr 2013 11:56:03 +0200
In-Reply-To: <1367315380.4616.91.camel@marge.simpson.net>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	 <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>
	 <20130412162348.GE2368@pd.tnic>
	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>
	 <1366989087.30242.11.camel@marge.simpson.net>
	 <1367298972.4616.41.camel@marge.simpson.net>
	 <1367310625.4616.71.camel@marge.simpson.net>
	 <20130430084135.GA21473@gmail.com>
	 <1367314539.4616.88.camel@marge.simpson.net>
	 <1367315380.4616.91.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:LRgWNm5fLvlZCWe3MEd/4tSOjOC884hN/Dh3WaCMhXN
 H1A261KjMtQ8VAllBtpPT8V3bHBZu7aPO6wTmjDvReu5v8x55+
 f4zGhg4YWZW/Qri34FnidT+F+ZZB2Ppdzad5ANPxQKETR5VUlz
 6ufZhliM0awnrf5VQPAAiQ2SQoeAsI/QuwWKEKH+OKP4mzaqO+
 uE6DsSqOtM1qyzQ2QCn+QuHv73my1OIiBy5UUTDoNjvfKVdetm
 6AUHqyskR/1XZC+raOHchovC6hiQh4j/9fuG69HuolsMW3v0py
 v1RAbFbT8qTDRTz4RlPZQzqUCDCCwxBXqphrNfUAstVtaWp490
 +YdRToO4Ny+Kt37B0Yivk4NAlldyOZ56TPI6RnI04kFtCWXHra
 bcFYnPJc/OGkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 11:49 +0200, Mike Galbraith wrote: 
> On Tue, 2013-04-30 at 11:35 +0200, Mike Galbraith wrote: 
> > On Tue, 2013-04-30 at 10:41 +0200, Ingo Molnar wrote: 
> 
> > > Which are the workloads where 'powersaving' mode hurts workload 
> > > performance measurably?
> > 
> > Well, it'll lose throughput any time there's parallel execution
> > potential but it's serialized instead.. using average will inevitably
> > stack tasks sometimes, but that's its goal.  Hackbench shows it.
> 
> (but that consolidation can be a winner too, and I bet a nickle it would
> be for a socket sized pgbench run)

(belay that, was thinking of keeping all tasks on a single node, but
it'll likely stack the whole thing on a CPU or two, if so, it'll hurt)

