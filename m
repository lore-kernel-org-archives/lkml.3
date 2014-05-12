Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaEMGEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:04:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:16753 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaEMGEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1041,1389772800"; 
   d="scan'208";a="431333416"
Date: Tue, 13 May 2014 05:59:56 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Doug Smythies <dsmythies@telus.net>,
        " linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
Message-ID: <20140512215956.GC10676@intel.com>
References: <bf3034d0-5c89-4ddb-921a-a92a4aed39f8@fmsmsx105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf3034d0-5c89-4ddb-921a-a92a4aed39f8@fmsmsx105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Maybe, in some cases yes. But not always. 
> > > For example, please consider a CPU running a tight "for" loop in 100MHz 
> > > for a couple of seconds. This produces a load of 100%. 
> > > It will produce the same load (100%) in any other frequency. 
> >
> > Still fundamentally wrong, because you are not making a fair 
> > comparison ("load" in 100MHz vs. any other freq). 
> >
> 
> I'm sorry, I didn't understand you. What do you mean it's not fair?
> 
> In the above example (considering a CPU with min freq 100MHz and max freq 1000Mhz) a load of 100% should also be 100 in other next frequency.
> 
> If we scale the load we will calculate the load in 100Mhz to 10%. I believe that this is not true.

The amount of work @100MHz is the same as the amount of work @1000MHZ, in your
example? Put another way, your proposed method does not do any extra better,
but do worse in other cases (what if @1000MHz, the load drops to 10%).

That said, your case cannot be used against associating freq with load. That also
said, by associating freq with load, we will finally get highest freq as well
(in your case).

Yuyang
