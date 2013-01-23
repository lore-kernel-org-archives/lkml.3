Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3AWEgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:36:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3AWEgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:36:51 -0500
Message-ID: <1358915494.5752.46.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Wed, 23 Jan 2013 05:31:34 +0100
In-Reply-To: <50FF4EA0.1070000@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Rm8CcXDmktT4kKU6MOZ0Y04pxuWJRXT0KAorRS5ZviW
 ztwCd0FnE63byHtAjP20PyM1R1y3OFgTA1ml7/7s+TdX4VC6vQ
 bIOzfyIfNDikN7dr79MwZpUZfjxQBt+zmIB9pfukLyviZv/XE2
 jhvcYuZVt6mw4XXvPCUqSwylTcRziRsL1mKL+KrDNaU6pnbFPL
 eMUgnMhpq3+p36Y9BU6g6IHqI63t2A8LNSVtr9b3suMmcbzVhn
 pYP6I/zXXeyZ74yDgSKjboQmCpFI/kJ3c7zx4FC68F41OQTTVc
 WiZljQptwollKBkzOO6s1G2AQ6Oxqq8s3/BHXK1gME2l0IbGjn
 ypTv7sC87OtRo7u203w8s7irwnmkxMWm45KfUJaym7aMxjtFEC
 ZzX/iolog0DLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:44 +0800, Michael Wang wrote: 
> On 01/22/2013 10:41 PM, Mike Galbraith wrote:
> > On Tue, 2013-01-22 at 16:56 +0800, Michael Wang wrote:
> > 
> >> What about this patch? May be the wrong map is the killer on balance
> >> path, should we check it? ;-) 
> > 
> > [    1.232249] Brought up 40 CPUs
> > [    1.236003] smpboot: Total of 40 processors activated (180873.90 BogoMIPS)
> > [    1.244744] CPU0 attaching sched-domain:
> > [    1.254131] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> > [    1.252010]  domain 0: span 0,16 level SIBLING
> > [    1.280001]   groups: 0 (cpu_power = 589) 16 (cpu_power = 589)
> > [    1.292540]   domain 1: span 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 level MC
> > [    1.312001]    groups: 0,16 (cpu_power = 1178) 2,18 (cpu_power = 1178) 4,20 (cpu_power = 1178) 6,22 (cpu_power = 1178) 8,24 (cpu_power = 1178)
> >                          10,26 (cpu_power = 1178)12,28 (cpu_power = 1178)14,30 (cpu_power = 1178)32,36 (cpu_power = 1178)34,38 (cpu_power = 1178)
> > [    1.368002]    domain 2: span 0-39 level NUMA
> > [    1.376001]     groups: 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 (cpu_power = 11780)
> >                            1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39 (cpu_power = 11780)
> 
> Thanks for the testing, that's not all the output but just for cpu 0,
> correct?

Yeah, I presumed one was enough.  You can have more if you like, there's
LOTS more where that came from (reboot is amazing with low speed serial
console -> high latency low bandwidth DSL conection;). 

> > [    1.412546] WYT: sbm of cpu 0
> > [    1.416001] WYT:      exec map
> > [    1.424002] WYT:              sd 6ce55000, idx 0, level 0, weight 2
> > [    1.436001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
> > [    1.448001] WYT:              sd 6cef3000, idx 3, level 3, weight 40
> > [    1.460001] WYT:      fork map
> > [    1.468001] WYT:              sd 6ce55000, idx 0, level 0, weight 2
> > [    1.480001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
> 
> This is not by design... sd in idx 2 should point to level 1 sd if there
> is no level 2 sd, this part is broken...oh, how could level 3 sd be
> there with out level 2 created? strange...
> 
> So with this map, the new balance path will no doubt broken, I think we
> got the reason, amazing ;-)
> 
> Let's see how to fix it, hmm... need some study firstly.

Another thing that wants fixing: root can set flags for _existing_
domains any way he likes, but when he invokes godly powers to rebuild
domains, he gets what's hard coded, which is neither clever (godly
wrath;), nor wonderful for godly runtime path decisions.

-Mike

