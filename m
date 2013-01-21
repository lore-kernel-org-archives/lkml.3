Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3AUI0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:26:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3AUI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:26:37 -0500
Message-ID: <1358756780.4994.104.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 09:26:20 +0100
In-Reply-To: <50FCEF6C.6010801@linux.vnet.ibm.com>
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
	 <50FCEF6C.6010801@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:lbGDTulmViE0802FJAiw4RZ2+0z9e5gMoqi54yO2T8O
 OYhbql7h8yB97VY6Xx48J14k+yEy5fCrNqU2GCzufJttD9lx7R
 7DtbImFP/zZ5wG1LtZqFhKyS9xz2ZYAGl6i52BjrdbPAkQUiyT
 /gYdnMHhyl5yzG+BVJmxzEPXLq+UQtRC/alWNXBHWxwqn1vY8O
 NjpEqShMszhStMNlE0lW2w4hTv0aaSdjl8Oijd/5SUg17LglzM
 ulE7LIYzPRwKEa7pyijcv3R7MjWYfeM+3hT+jJwMhJkIT/z5L5
 Xm4tHJcNJKM2QgbKHd0D0sov9cjbtxeAoPVWlTRIDbrjcf5FT7
 +zM52lMKj2j0Z3XNFS9Vda9RKiJ1DFEa4GcNJ4XtFw6tJqUgVH
 3EVOj1B0yYCoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 15:34 +0800, Michael Wang wrote: 
> On 01/21/2013 02:42 PM, Mike Galbraith wrote:
> > On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> > 
> >> That seems like the default one, could you please show me the numbers in
> >> your datapoint file?
> > 
> > Yup, I do not touch the workfile.  Datapoints is what you see in the
> > tabulated result...
> > 
> > 1
> > 1
> > 1
> > 5
> > 5
> > 5
> > 10
> > 10
> > 10
> > ...
> > 
> > so it does three consecutive runs at each load level.  I quiesce the
> > box, set governor to performance, echo 250 32000 32 4096
> >> /proc/sys/kernel/sem, then ./multitask -nl -f, and point it
> > at ./datapoints.
> 
> I have changed the "/proc/sys/kernel/sem" to:
> 
> 2000    2048000 256     1024
> 
> and run few rounds, seems like I can't reproduce this issue on my 12 cpu
> X86 server:
> 
> 	prev		post
> Tasks    jobs/min  	jobs/min
>     1      508.39    	506.69
>     5     2792.63   	2792.63
>    10     5454.55   	5449.64
>    20    10262.49  	10271.19
>    40    18089.55  	18184.55
>    80    28995.22  	28960.57
>   160    41365.19  	41613.73
>   320    53099.67  	52767.35
>   640    61308.88  	61483.83
>  1280    66707.95  	66484.96
>  2560    69736.58  	69350.02
> 
> Almost nothing changed...I would like to find another machine and do the
> test again later.

Hm.  Those numbers look odd.  Ok, I've got 8 more cores, but your hefty
load throughput is low.  When I look low end numbers, seems your cores
are more macho than my 2.27 GHz EX cores, so it should have been a lot
closer.  Oh wait, you said "12 cpu".. so 1 6 core package + HT?  This
box is 2 NUMA nodes (was 4), 2 (was 4) 10 core packages + HT.

-Mike

