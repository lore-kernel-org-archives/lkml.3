Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3EHVQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:16:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39917 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EHVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:16:49 -0400
Date: Wed, 8 May 2013 14:16:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_preempt running flat out on idle desktop.
Message-ID: <20130508211634.GP3648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130508203042.GA18895@redhat.com>
 <20130508205258.GN3648@linux.vnet.ibm.com>
 <20130508205633.GB18895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508205633.GB18895@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050821-7606-0000-0000-00000B343FC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 04:56:33PM -0400, Dave Jones wrote:
> On Wed, May 08, 2013 at 01:52:58PM -0700, Paul E. McKenney wrote:
>  > On Wed, May 08, 2013 at 04:30:42PM -0400, Dave Jones wrote:
> 
>  > >   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND 
>  > >    10 root      20   0     0    0    0 S 200.0  0.0 185301:36 rcu_preempt
>  > >   553 root      20   0  268m  76m 6764 S 200.0  2.6 144579:53 Xorg
>  > >  1199 root      20   0     0    0    0 S 200.0  0.0 306:17.85 kworker/1:0
>  > >   501 root      20   0     0    0    0 S 200.0  0.0   4471:03 kworker/0:2
>  > >    12 root      20   0     0    0    0 S 200.0  0.0  67277:16 rcuop/1
>  > >  1237 davej     20   0  535m  15m 8484 S 200.0  0.5   3645:16 Terminal
>  > >   859 davej     20   0  117m 3036 1336 S 200.0  0.1   1986:55 htop
>  > > 
>  > > There are a lot of processes allegedly using "200%" of CPU time, a handful
>  > > in the "196%" range, and then a bunch at 0.
>  > 
>  > Yow!!!  185301 minutes is 128 days, which is a truly impressive amount of
>  > CPU time to accumulate in a few short hours.
> 
> perf top doesn't show anything out of the ordinary. Just as an idle desktop
> should behave, it's spending a bunch of time in delay_tsc.
> 
>  > This is 3.9, or Linus's current tree?  I am guessing the latter, but
>  > figured I should ask.
> 
> Yeah, the latter. (v3.9-11572-g5af43c2)

Do you have CONFIG_NO_HZ_FULL=y?  We just might have a bug in tickless
CPU-time accounting...

							Thanx, Paul

