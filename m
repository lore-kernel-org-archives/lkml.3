Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaDAX2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:28:55 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:22926 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaDAX2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:28:53 -0400
Message-ID: <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 01 Apr 2014 16:28:51 -0700
In-Reply-To: <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	 <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	 <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	 <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>
	 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
	 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
	 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
	 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
	 <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
	 <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
	 <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 18:49 -0400, KOSAKI Motohiro wrote:
> On Tue, Apr 1, 2014 at 5:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 1 Apr 2014 17:41:54 -0400 KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> >
> >> >> > Hmmm so 0 won't really work because it could be weirdly used to disable
> >> >> > shm altogether... we cannot go to some negative value either since we're
> >> >> > dealing with unsigned, and cutting the range in half could also hurt
> >> >> > users that set the limit above that. So I was thinking of simply setting
> >> >> > SHMMAX to ULONG_MAX and be done with it. Users can then set it manually
> >> >> > if they want a smaller value.
> >> >> >
> >> >> > Makes sense?
> >> >>
> >> >> I don't think people use 0 for disabling. but ULONG_MAX make sense to me too.
> >> >
> >> > Distros could have set it to [U]LONG_MAX in initscripts ten years ago
> >> > - less phone calls, happier customers.  And they could do so today.
> >> >
> >> > But they haven't.   What are the risks of doing this?
> >>
> >> I have no idea really. But at least I'm sure current default is much worse.
> >>
> >> 1. Solaris changed the default to total-memory/4 since Solaris 10 for DB.
> >>  http://www.postgresql.org/docs/9.1/static/kernel-resources.html
> >>
> >> 2. RHEL changed the default to very big size since RHEL5 (now it is
> >> 64GB). Even tough many box don't have 64GB memory at that time.
> >
> > Ah-hah, that's interesting info.
> >
> > Let's make the default 64GB?
> 
> 64GB is infinity at that time, but it no longer near infinity today. I like
> very large or total memory proportional number.

So I still like 0 for unlimited. Nice, clean and much easier to look at
than ULONG_MAX. And since we cannot disable shm through SHMMIN, I really
don't see any disadvantages, as opposed to some other arbitrary value.
Furthermore it wouldn't break userspace: any existing sysctl would
continue to work, and if not set, the user never has to worry about this
tunable again.

Please let me know if you all agree with this...

