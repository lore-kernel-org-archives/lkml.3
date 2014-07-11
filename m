Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaGKN4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:56:13 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:37484 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbaGKN4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:56:09 -0400
Date: Fri, 11 Jul 2014 08:56:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
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
In-Reply-To: <20140711132032.GB26045@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1407110855030.25432@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <20140711132032.GB26045@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Frederic Weisbecker wrote:

> > @@ -1228,20 +1244,105 @@ static const struct file_operations proc
> >  #ifdef CONFIG_SMP
> >  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
> >  int sysctl_stat_interval __read_mostly = HZ;
> > +struct cpumask *cpu_stat_off;
>
> I thought you converted it?

Converted what? We still need to keep a cpumask around that tells us which
processor have vmstat running and which do not.

