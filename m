Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaLCFWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:22:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49063 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaLCFWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:22:49 -0500
Date: Tue, 2 Dec 2014 21:22:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203052244.GH25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547D7B05.6080403@cn.fujitsu.com>
 <547defc3.28568c0a.73eb.1a1e@mx.google.com>
 <547E6F8C.1060709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547E6F8C.1060709@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120305-0029-0000-0000-00000611377C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:03:56AM +0800, Lai Jiangshan wrote:
> On 12/03/2014 12:58 AM, Dâniel Fraga wrote:
> > On Tue, 2 Dec 2014 16:40:37 +0800
> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> >> It is needed at lest for testing.
> >>
> >> CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.
> >>
> >> Please enable them (or enable them under CONFIG_RCU_TRACE=y)
> > 
> > 	Lai, sorry but I didn't understand. Do you mean both of them
> > enabled? Because how can CONFIG_TREE_PREEMPT_RCU be enabled without
> > CONFIG_PREEMPT ?
> 
> 
> Sorry, I replied to Paul, and my reply was off-topic, it has nothing
> related your reports. Sorry again.
> 
> I think we need two combinations for testing (not mainline, but I think
> they (combinations) should be enabled for test farms).
> 
> So I hope Paul enable them (combinations).
> 
> combination1: CONFIG_TREE_PREEMPT_RCU=n & CONFIG_PREEMPT=y
> combination2: CONFIG_TREE_PREEMPT_RCU=y & CONFIG_PREEMPT=n
> 
> The core code should work correctly in these combinations.
> I agree with Paul that these combinations should not be enabled in production,
> So my request is: enable these combinations under CONFIG_RCU_TRACE
> or CONFIG_TREE_RCU_TRACE.
> 
> For myself, I always edit the Kconfig directly, thus it is not a problem
> for me.  But there is no way for test farms to test these combinations.

OK, I'll bite...

How have these two combinations helped you in your testing?

The reason I ask is that I am actually trying to -decrease- the RCU
configurations, not increase them.  Added configurations need to have
strong justification, for example, the kernel-tracing/patching need
for tasks_rcu.

							Thanx, Paul

> Thanks,
> Lai
> 
> > 
> > 	If you mean both enabled, I already reported a call trace with
> > both enabled:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=85941
> > 
> > 	Please see my previous answer to Linus and Paul too.
> > 
> > 	Regarding CONFIG_RCU_TRACE, do you mean
> > "CONFIG_TREE_RCU_TRACE"? I couldn't find CONFIG_RCU_TRACE.
> > 
> > 	Thanks.
> > 
> 

