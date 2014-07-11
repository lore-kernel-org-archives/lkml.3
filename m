Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaGKN7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:59:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47138 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaGKN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:59:08 -0400
Date: Fri, 11 Jul 2014 15:58:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
Message-ID: <20140711135854.GD26045@localhost.localdomain>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
 <20140711132032.GB26045@localhost.localdomain>
 <alpine.DEB.2.11.1407110855030.25432@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407110855030.25432@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:56:04AM -0500, Christoph Lameter wrote:
> On Fri, 11 Jul 2014, Frederic Weisbecker wrote:
> 
> > > @@ -1228,20 +1244,105 @@ static const struct file_operations proc
> > >  #ifdef CONFIG_SMP
> > >  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
> > >  int sysctl_stat_interval __read_mostly = HZ;
> > > +struct cpumask *cpu_stat_off;
> >
> > I thought you converted it?
> 
> Converted what? We still need to keep a cpumask around that tells us which
> processor have vmstat running and which do not.
> 

Converted to cpumask_var_t.

I mean we spent dozens emails on that...
