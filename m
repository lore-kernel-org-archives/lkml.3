Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3KBDPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 23:15:19 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1742 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3KBDPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 23:15:17 -0400
Message-ID: <1383362113.2444.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
From: Davidlohr Bueso <davidlohr@hp.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Date: Fri, 01 Nov 2013 20:15:13 -0700
In-Reply-To: <20131101101643.GC30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20131101080135.GB25547@gmail.com>
	 <20131101081159.GB12829@yliu-dev.sh.intel.com>
	 <20131101082146.GA27021@gmail.com>
	 <20131101101643.GC30123@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 18:16 +0800, Yuanhan Liu wrote:
> On Fri, Nov 01, 2013 at 09:21:46AM +0100, Ingo Molnar wrote:
> > 
> > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > 
> > > > Btw., another _really_ interesting comparison would be against 
> > > > the latest rwsem patches. Mind doing such a comparison?
> > > 
> > > Sure. Where can I get it? Are they on some git tree?
> > 
> > I've Cc:-ed Tim Chen who might be able to point you to the latest 
> > version.
> > 
> > The last on-lkml submission was in this thread:
> > 
> >   Subject: [PATCH v8 0/9] rwsem performance optimizations
> > 
> 
> Thanks.
> 
> I queued bunchs of tests about one hour ago, and already got some
> results(If necessary, I can add more data tomorrow when those tests are
> finished):

What kind of system are you using to run these workloads on?

> 
> 
>                v3.12-rc7      fe001e3de090e179f95d  
> ------------------------  ------------------------  
>                                 -9.3%               brickland1/micro/aim7/shared
>                                 +4.3%               lkp-ib03/micro/aim7/fork_test
>                                 +2.2%               lkp-ib03/micro/aim7/shared
>                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> 

Sorry if I'm missing something, but could you elaborate more on what
these percentages represent? Are they anon vma rwsem + optimistic
spinning patches vs anon vma rwlock?

Also, I see your running aim7, you might be interested in some of the
results I found when trying out Ingo's rwlock conversion patch on a
largish 80 core system: https://lkml.org/lkml/2013/9/29/280

Thanks,
Davidlohr

