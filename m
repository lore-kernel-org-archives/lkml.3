Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab3BTPWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:22:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36633 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3BTPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:22:32 -0500
Message-ID: <1361373740.10155.42.camel@laptop>
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 16:22:20 +0100
In-Reply-To: <5124DED5.5050207@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	  <1361164062-20111-7-git-send-email-alex.shi@intel.com>
	 <1361352643.10155.4.camel@laptop> <5124DED5.5050207@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 22:33 +0800, Alex Shi wrote:
> > You don't actually compute the rq utilization, you only compute the
> > utilization as per the fair class, so if there's significant RT
> activity
> > it'll think the cpu is under-utilized, whihc I think will result in
> the
> > wrong thing.
> 
> yes. A bit complicit to resolve this. Any suggestions on this, guys?

Shouldn't be too hard seeing as we already track cpu utilization for !
fair usage; see rq::rt_avg and scale_rt_power.

