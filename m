Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3C2RkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:40:12 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:44572 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3C2RkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:40:09 -0400
Date: Fri, 29 Mar 2013 10:40:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
Message-ID: <20130329174003.GA9862@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
 <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
 <20130321001211.GC31256@htj.dyndns.org>
 <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
 <20130321182937.GB20500@htj.dyndns.org>
 <20130328181332.GD14088@htj.dyndns.org>
 <CAKohpomkGxUy6-7tByBjQvAGSUn4EdVCpGo+94fn7vF8YgKRLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomkGxUy6-7tByBjQvAGSUn4EdVCpGo+94fn7vF8YgKRLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Fri, Mar 29, 2013 at 12:57:23PM +0530, Viresh Kumar wrote:
> On 28 March 2013 23:43, Tejun Heo <tj@kernel.org> wrote:
> > Viresh, would it be difficult to make another measurement of the same
> > workload with the said workqueues converted to unbound?  I think that
> > would at least provide a nice reference point.
> 
> My heart is shattered after getting the results :)
> 
> 
> Cluster A15 Energy      Cluster A7 Energy       Total
> -------------------------      -----------------------       ------
> 
> Without this patchset (Energy in Joules):
> ---------------------------------------------------
> 0.322866                2.619137                2.942003
> 
> 
> With this patchset (Energy in Joules):
> -----------------------------------------------
> 0.182721                2.443745                2.626466
> 
> 
> With WQ Unbound (Energy in Joules):
> -----------------------------------------------
> 0.2289042              2.2514632              2.4803674


So the scheduler does know what it's doing after all, which is a nice
news.  Given the result, the best thing to do would be somehow marking
these workqueues as unbound for powersaving?

Thanks!

-- 
tejun
