Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbaISPLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:11:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbaISPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:12 -0400
Date: Fri, 19 Sep 2014 01:15:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/2] sched: let the scheduler see CPU idle states
Message-ID: <20140918231544.GN2848@worktop.localdomain>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-2-git-send-email-nicolas.pitre@linaro.org>
 <20140918173733.GQ4723@linux.vnet.ibm.com>
 <20140918173925.GA7337@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918173925.GA7337@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:39:25AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 18, 2014 at 10:37:33AM -0700, Paul E. McKenney wrote:

> > A stop_cpus() will force a context switch on all CPUs, though it is
> > a rather big hammer.
> 
> And I was reminded by the very next email that kick_all_cpus_sync() is
> another possibility -- it forces an interrupt on all online CPUs, idle
> or not.

I actually have a patch
http://lkml.kernel.org/r/1409815075-4180-2-git-send-email-chuansheng.liu@intel.com
that changes that, because apparently there are idle loops that don't
actually exit on interrupt :-)

But yes, something like the wake_up_all_idle_cpus() should do.
