Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3I1Vdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:33:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39711 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3I1Vdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:33:49 -0400
Date: Sat, 28 Sep 2013 14:33:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] cpuidle: create list of registered drivers
Message-ID: <20130928213343.GA19582@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1379779777.git.viresh.kumar@linaro.org>
 <7e9565e323c1e065eeb2a2a1075967bd21ee6066.1379779777.git.viresh.kumar@linaro.org>
 <5243641B.6050604@linaro.org>
 <CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>
 <5243EE02.9020207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243EE02.9020207@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092821-0928-0000-0000-00000219A66A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 10:19:14AM +0200, Daniel Lezcano wrote:
> On 09/26/2013 08:17 AM, Viresh Kumar wrote:
> >On 26 September 2013 04:00, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >>If you introduce a list, you will have to introduce a lock to protect
> >>it.
> >
> >I missed it, should have added that :)
> >
> >>This lock will be in the fast path cpuidle_idle_call with the
> >>get_driver function and conforming to the comment: "NOTE: no locks or
> >>semaphores should be used here".
> >>
> >>A lock has been introduced in this function already and the system hangs
> >>with 1024 cpus.
> >
> >Hmm... I see.. I didn't knew about this expectation.. What about a rcu
> >read/write lock? As far as I know its too lightweight... Can we have that
> >in fast path?
> 
> Nope, we can't use rcu in the idle path :)
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/083054.html

But you should be able to use SRCU in the idle path, if that helps.

							Thanx, Paul

