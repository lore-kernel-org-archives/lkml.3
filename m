Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3ENOH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:07:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3ENOHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:07:24 -0400
Message-ID: <1368540440.6275.32.camel@marge.simpson.net>
Subject: Re: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 16:07:20 +0200
In-Reply-To: <20130514005744.GA12749@somewhere>
References: <1368346669.5998.13.camel@marge.simpson.net>
	 <20130514005744.GA12749@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:z0wuv4fsx5ZYQgm5X1TdfEOKESrc21OVcxIj/HOPPo6
 P0o/byPXISx8HB+r45oyJ0ArKxdKdJ8rmoSs/MeETrsB4YT6MI
 EkTUixQF9rWMvf34Ab43ZcRQXWg6bTz3fD//W9c1CeBjeroiD2
 jhSrly/OvTNJQZPL2CU7ouKmGpo4kSOh4110gO38fnLL2zoKJP
 IpNEFuRQ4ogBY8g2mae1HjfqmrrC3UZNfwa76iVA5vJeSjaL38
 SNCT9zfQWepsEGrZfTrZyxEvOxAVCxiQ1y3a3FFsESlsegUV3R
 a1CwWtOtPC3xDL8y68fgaNXKE3kr+xexRhHYXFUkhe9zuoOQLH
 Vm4ZxhNcddf86QVYikuVKCvfMw+ueG3dV9g2pARzPMKWSbKDgb
 zoCV74Lw7kcQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 02:57 +0200, Frederic Weisbecker wrote: 
> On Sun, May 12, 2013 at 10:17:49AM +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
> > accrue zero utime/stime.  However, the same exact kernel on E5620 box
> > works fine, so it would appear there's a CPU dependency somewhere.
> 
> Ah indeed, I just managed to reproduce the same issue.
> 
> > 
> > Is core2 expected to go dysfunctional with context tracking enabled?
> > CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
> > CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
> > boxen only, same exact kernel continues to work just fine on E5620
> > (Westmere) box.
> 
> There was no known issue with core2. The box where I'm seeing the it
> is a Phenom quad core that had NR_CPUS=2. May be the issue is more
> likely to happen with this low number. I don't know.
> 
> I'm investigating further.

So with CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, you can't mix sched_clock()
(pure tsc) with local_clock()/sched_clock_cpu(cpu).  The former is
always quite a bit ahead of the later, so mixing clocks is a nogo on
crusty old (but beloved) core2 box.

-Mike

