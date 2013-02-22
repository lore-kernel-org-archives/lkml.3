Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3BVODR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:03:17 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32996 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3BVODP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:03:15 -0500
Date: Fri, 22 Feb 2013 15:03:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
Message-ID: <20130222140306.GA18149@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361512604-2720-2-git-send-email-khilman@linaro.org>
 <20130222133835.GF17948@somewhere.redhat.com>
 <1361541531.26780.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361541531.26780.57.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 02:58:51PM +0100, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 14:38 +0100, Frederic Weisbecker wrote:
> > Looks good, just a minor neat:
> > 
> > On Thu, Feb 21, 2013 at 09:56:43PM -0800, Kevin Hilman wrote:
> > > diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> > > index 66b7078..df8ad75 100644
> > > --- a/include/linux/kernel_stat.h
> > > +++ b/include/linux/kernel_stat.h
> > > @@ -32,7 +32,7 @@ enum cpu_usage_stat {
> > >  };
> > >  
> > >  struct kernel_cpustat {
> > > -	u64 cpustat[NR_STATS];
> > > +	u64 _cpustat[NR_STATS];
> > 
> > Why do you need the underscore?
> 
> To make sure there's nobody still referencing the data directly instead
> of through the accessors.

Good point!
