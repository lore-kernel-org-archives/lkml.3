Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3GICgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 22:36:50 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37992 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GICgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 22:36:49 -0400
Message-ID: <1373337407.1744.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 08 Jul 2013 19:36:47 -0700
In-Reply-To: <51DB75D4.6050302@linux.vnet.ibm.com>
References: <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
	 <1372997318.7315.23.camel@marge.simpson.net>
	 <51D64C84.5080100@linux.vnet.ibm.com>
	 <1373002865.8318.11.camel@marge.simpson.net>
	 <51D664B9.7010407@linux.vnet.ibm.com>
	 <1373179405.19316.41.camel@marge.simpson.net>
	 <20130708082106.GW23916@twins.programming.kicks-ass.net>
	 <1373309998.1744.3.camel@buesod1.americas.hpqcorp.net>
	 <51DB75D4.6050302@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 10:30 +0800, Michael Wang wrote:
> Hi, Davidlohr
> 
> Thanks for the testing :)
> 
> On 07/09/2013 02:59 AM, Davidlohr Bueso wrote:
> [snip]
> >>
> >> OK, I'll apply the patches, we'll see what happens. If there significant
> >> fallout we'll immediately have more information anyway ;-)
> > 
> > So I gave the v2 a spin on my aim7 benchmark on an 80-core 8 socket
> > DL980. Not much changed, most numbers are in the noise range, however,
> > with HT off, the high_systime workload suffered in throughput with this
> > patch with higher concurrency (after 600 users). Image attached.
> 
> To make sure I'm not on the wrong way... HT here means hyperthreading,
> correct?

Yep :)

> 
> I have some questions like:
> 1. how do you disable the hyperthreading? by manual or some other way?

Manually, from the BIOS.

> 2. is the 3.10-rc5 in image also disabled the hyperthreading?

Yes, I happened to have data already collected for 3.10-rc5. While the
runs with this patch was with -rc7, unless there was some performance
related commit I missed, I don't think the performance difference was
because of that.

> 3. is the v3 patch set show the same issue?

Uhmmm shoot, I didn't realize there was a v3, sorry about that.

/me takes another look at the thread.

Thanks,
Davidlohr

