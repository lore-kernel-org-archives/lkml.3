Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3DZPLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:11:47 -0400
Received: from mout.gmx.net ([212.227.17.22]:58589 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3DZPLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:11:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+mmjk3ZT2mFkBLvD5V4oqaS6uUNwtd/1GgcggoSD
	I3yerEo5WIdnj2
Message-ID: <1366989087.30242.11.camel@marge.simpson.net>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
From: Mike Galbraith <efault@gmx.de>
To: Len Brown <lenb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Date: Fri, 26 Apr 2013 17:11:27 +0200
In-Reply-To: <516F19EE.5060309@kernel.org>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	 <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>
	 <20130412162348.GE2368@pd.tnic>
	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 17:53 -0400, Len Brown wrote: 
> On 04/12/2013 12:48 PM, Mike Galbraith wrote:
> > On Fri, 2013-04-12 at 18:23 +0200, Borislav Petkov wrote: 
> >> On Fri, Apr 12, 2013 at 04:46:50PM +0800, Alex Shi wrote:
> >>> Thanks a lot for comments, Len!
> >>
> >> AFAICT, you kinda forgot to answer his most important question:
> >>
> >>> These numbers suggest that this patch series simultaneously
> >>> has a negative impact on performance and energy required
> >>> to retire the workload.  Why do it?
> > 
> > Hm.  When I tested AIM7 compute on a NUMA box, there was a marked
> > throughput increase at the low to moderate load end of the test spectrum
> > IIRC.  Fully repeatable.  There were also other benefits unrelated to
> > power, ie mitigation of the evil face of select_idle_sibling().  I
> > rather liked what I saw during ~big box test-drive.
> > 
> > (just saying there are other aspects besides joules in there)
> 
> Mike,
> 
> Can you re-run your AIM7 measurement with turbo-mode and HT-mode disabled,
> and then independently re-enable them?
> 
> If you still see the performance benefit, then that proves
> that the scheduler hacks are not about tricking into
> turbo mode, but something else.

I did that today, neither turbo nor HT affected the performance gain.  I
used the same box and patch set as tested before (v4), but plugged into
linus HEAD.  "powersaving" AIM7 numbers are ~identical to those I posted
before, "performance" is lower at the low end of AIM7 test spectrum, but
as before, delta goes away once the load becomes hefty.

-Mike

