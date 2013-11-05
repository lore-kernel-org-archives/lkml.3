Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3KECDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:03:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:5305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab3KECDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:03:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403654512"
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
In-Reply-To: <1383615840.11046.265.camel@schen9-DESK>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20131101080135.GB25547@gmail.com>
	 <20131101081159.GB12829@yliu-dev.sh.intel.com>
	 <20131101082146.GA27021@gmail.com>
	 <20131101101643.GC30123@yliu-dev.sh.intel.com>
	 <1383362113.2444.5.camel@buesod1.americas.hpqcorp.net>
	 <20131104035920.GH30123@yliu-dev.sh.intel.com>
	 <1383615840.11046.265.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Nov 2013 18:03:12 -0800
Message-ID: <1383616992.11046.271.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-04 at 17:44 -0800, Tim Chen wrote:
> On Mon, 2013-11-04 at 11:59 +0800, Yuanhan Liu wrote:
> > On Fri, Nov 01, 2013 at 08:15:13PM -0700, Davidlohr Bueso wrote:
> > > On Fri, 2013-11-01 at 18:16 +0800, Yuanhan Liu wrote:
> > > > On Fri, Nov 01, 2013 at 09:21:46AM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > > > 
> > > > > > > Btw., another _really_ interesting comparison would be against 
> > > > > > > the latest rwsem patches. Mind doing such a comparison?
> > > > > > 
> > > > > > Sure. Where can I get it? Are they on some git tree?
> > > > > 
> > > > > I've Cc:-ed Tim Chen who might be able to point you to the latest 
> > > > > version.
> > > > > 
> > > > > The last on-lkml submission was in this thread:
> > > > > 
> > > > >   Subject: [PATCH v8 0/9] rwsem performance optimizations
> > > > > 
> > > > 
> > > > Thanks.
> > > > 
> > > > I queued bunchs of tests about one hour ago, and already got some
> > > > results(If necessary, I can add more data tomorrow when those tests are
> > > > finished):
> > > 
> > > What kind of system are you using to run these workloads on?
> > 
> > I queued jobs on 5 testboxes:
> >   - brickland1: 120 core Ivybridge server
> >   - lkp-ib03:   48 core Ivybridge server
> >   - lkp-sb03:   32 core Sandybridge server
> >   - lkp-nex04:  64 core NHM server
> >   - lkp-a04:    Atom server
> > > 
> > > > 
> > > > 
> > > >                v3.12-rc7      fe001e3de090e179f95d  
> > > > ------------------------  ------------------------  
> > > >                                 -9.3%               brickland1/micro/aim7/shared
> > > >                                 +4.3%               lkp-ib03/micro/aim7/fork_test
> > > >                                 +2.2%               lkp-ib03/micro/aim7/shared
> > > >                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> > > > 
> > > 
> > > Sorry if I'm missing something, but could you elaborate more on what
> > > these percentages represent?
> > 
> >                v3.12-rc7      fe001e3de090e179f95d  
> > ------------------------  ------------------------  
> >                                 -9.3%               brickland1/micro/aim7/shared
> > ....
> > ....
> >                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> > 
> > The comparation base is v3.12-rc7, and we got 9.3 performance regression
> > at commit fe001e3de090e179f95d, which is the head of rwsem performance
> > optimizations patch set.
> 
> Yunahan, thanks for the data.  This I assume is with the entire rwsem
> v8 patchset. Any idea of the run variation on the workload?

Yunhan,

I haven't got a chance to make multiple runs to check the standard
deviation.  From the few runs I did, I got a 5.1% increase in
performance for aim7 shared workload for the complete rwsem patchset
on a similar machine that you are using.  The patches are applied
to the 3.12-rc7 and compared to the vanilla kernel.

Thanks.

Tim

