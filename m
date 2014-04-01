Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaDAVny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:43:54 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:43140 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaDAVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:43:51 -0400
Message-ID: <1396388629.25314.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 01 Apr 2014 14:43:49 -0700
In-Reply-To: <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 17:12 -0400, KOSAKI Motohiro wrote:
> On Tue, Apr 1, 2014 at 5:01 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > On Tue, 2014-04-01 at 15:51 -0400, KOSAKI Motohiro wrote:
> >> >> So, I personally like 0 byte per default.
> >> >
> >> > If by this you mean 0 bytes == unlimited, then I agree. It's less harsh
> >> > then removing it entirely. So instead of removing the limit we can just
> >> > set it by default to 0, and in newseg() if shm_ctlmax == 0 then we don't
> >> > return EINVAL if the passed size is great (obviously), otherwise, if the
> >> > user _explicitly_ set it via sysctl then we respect that. Andrew, do you
> >> > agree with this? If so I'll send a patch.
> >>
> >> Yes, my 0 bytes mean unlimited. I totally agree we shouldn't remove the knob
> >> entirely.
> >
> > Hmmm so 0 won't really work because it could be weirdly used to disable
> > shm altogether... we cannot go to some negative value either since we're
> > dealing with unsigned, and cutting the range in half could also hurt
> > users that set the limit above that. So I was thinking of simply setting
> > SHMMAX to ULONG_MAX and be done with it. Users can then set it manually
> > if they want a smaller value.
> >
> > Makes sense?
> 
> I don't think people use 0 for disabling. but ULONG_MAX make sense to me too.

Yeah, you're right, SHMMNI is 1 and users _cannot_ change it.

