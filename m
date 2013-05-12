Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3ELRVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 13:21:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58514 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3ELRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 13:21:41 -0400
Date: Sun, 12 May 2013 10:21:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Message-ID: <20130512172135.GJ3648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87ip2opntp.fsf@nemi.mork.no>
 <20130512113905.GH3648@linux.vnet.ibm.com>
 <87li7kp50r.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87li7kp50r.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051217-7408-0000-0000-00001017F0E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 05:55:00PM +0200, Bjørn Mork wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> > On Sun, May 12, 2013 at 11:08:50AM +0200, Bjørn Mork wrote:
> >> Hello,
> >> 
> >> got the splat below when running powertop on plain v3.10-rc1
> >> (i.e. without my previously mentioned revert patch or any other extra
> >> patches).  Config attached.
> >
> > OK, it looks like you have context-tracking enabled, so you might be
> > hitting a bug that Steven Rostedt found a few days ago.  Could you
> > please try out his fix below?
> 
> Thanks for the quick reply, but I'm afraid that patch had no effect on
> the warning I got. It's still there.

Other than wondering whether powertop has issues similar to the bug
Steven Rostedt located, I must confess myself clueless.  Here are some
diagnostics I can suggest:

1.	Run in 32-bit mode.  This disables some of the new adaptive-ticks
	functionality, so might give a probabilistic indication of where
	the bug lies.

2.	The standard fallback of bisection.

Would you be willing to do either of these?

							Thanx, Paul

