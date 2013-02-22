Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3BVN7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:59:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3BVN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:59:05 -0500
Message-ID: <1361541531.26780.57.camel@laptop>
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 14:58:51 +0100
In-Reply-To: <20130222133835.GF17948@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	 <1361512604-2720-2-git-send-email-khilman@linaro.org>
	 <20130222133835.GF17948@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:38 +0100, Frederic Weisbecker wrote:
> Looks good, just a minor neat:
> 
> On Thu, Feb 21, 2013 at 09:56:43PM -0800, Kevin Hilman wrote:
> > diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> > index 66b7078..df8ad75 100644
> > --- a/include/linux/kernel_stat.h
> > +++ b/include/linux/kernel_stat.h
> > @@ -32,7 +32,7 @@ enum cpu_usage_stat {
> >  };
> >  
> >  struct kernel_cpustat {
> > -	u64 cpustat[NR_STATS];
> > +	u64 _cpustat[NR_STATS];
> 
> Why do you need the underscore?

To make sure there's nobody still referencing the data directly instead
of through the accessors.


