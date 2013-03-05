Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3CEUSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:18:30 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39411 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3CEUS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:18:29 -0500
Message-ID: <1362514677.6267.12.camel@lambeau>
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Date: Tue, 05 Mar 2013 14:17:57 -0600
In-Reply-To: <20130218235718.GB6166@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
	 <20130205214941.4615.29852.stgit@lambeau> <20130218235718.GB6166@amt.cnet>
Organization: IBM-LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030520-7182-0000-0000-000005A75ED2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in the response.  I did not see your question.

On Mon, 2013-02-18 at 20:57 -0300, Marcelo Tosatti wrote:
> On Tue, Feb 05, 2013 at 03:49:41PM -0600, Michael Wolf wrote:
> > Add a helper routine to scheduler/core.c to allow the kvm module
> > to retrieve the cpu hardlimit settings.  The values will be used
> > to set up a timer that is used to separate the consigned from the
> > steal time.
> 
> 1) Can you please describe, in english, the mechanics of subtracting cpu
> hardlimit values from steal time reported via run_delay supposed to
> work?
> 
> "The period and the quota used to separate the consigned time 
> (expected steal) from the steal time are taken
> from the cfs bandwidth control settings. Any other steal time
> accruing during that period will show as the traditional steal time."
> 
> There is no "expected steal time" over a fixed period of real time.
There is expected steal time in the sense that the administrator of the
system sets up guests on the host so that there will be cpu
overcommitment.  The end user who is using the guest does not know this,
they only know they have been guaranteed a certain level of performance.
So if steal time shows up the end user typically thinks they are not
getting their guaranteed performance. So this patchset is meant to allow
top to show 100% utilization and ONLY show steal time if it is over the
level of steal time that the host administrator setup.  So take a simple
example of a host with 1 cpu and two guest on it.  If each guest is
fully utilized a user will see 50% utilization and 50% steal in either
of the guests.  In this case the amount of steal time that the host 
administrator would expect to see is 50%.  As long as the steal in the
guest does not exceed 50% the guest is running as expected.  If for some
reason the steal increases to 60%, now something is wrong and the steal
time needs to be reported and the end user will make inquiries?

> 
> 2) From the description of patch 1: "In the case of where you have
> a system that is running in a capped or overcommitted environment 
> the user may see steal time being reported in accounting tools 
> such as top or vmstat." 
> 
> This is outdated, right? Because overcommitted environment is exactly
> what steal time should report.

I hope I'm not missing your point here.  But again this comes down to
the point of view.  The end user is guaranteed a capability/level of
performance that may not be a whole cpu.  So only show steal time if the
amount of steal time exceeds what the host admin expected when the guest
was set up.
> 
> 
> Thanks

thanks
Mike Wolf

