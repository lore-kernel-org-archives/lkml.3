Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaDAVsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:48:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaDAVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:48:03 -0400
Date: Tue, 1 Apr 2014 14:48:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
Message-Id: <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
In-Reply-To: <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
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
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014 17:41:54 -0400 KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> >> > Hmmm so 0 won't really work because it could be weirdly used to disable
> >> > shm altogether... we cannot go to some negative value either since we're
> >> > dealing with unsigned, and cutting the range in half could also hurt
> >> > users that set the limit above that. So I was thinking of simply setting
> >> > SHMMAX to ULONG_MAX and be done with it. Users can then set it manually
> >> > if they want a smaller value.
> >> >
> >> > Makes sense?
> >>
> >> I don't think people use 0 for disabling. but ULONG_MAX make sense to me too.
> >
> > Distros could have set it to [U]LONG_MAX in initscripts ten years ago
> > - less phone calls, happier customers.  And they could do so today.
> >
> > But they haven't.   What are the risks of doing this?
> 
> I have no idea really. But at least I'm sure current default is much worse.
> 
> 1. Solaris changed the default to total-memory/4 since Solaris 10 for DB.
>  http://www.postgresql.org/docs/9.1/static/kernel-resources.html
> 
> 2. RHEL changed the default to very big size since RHEL5 (now it is
> 64GB). Even tough many box don't have 64GB memory at that time.

Ah-hah, that's interesting info.

Let's make the default 64GB?

Then we can blame RH if something goes wrong ;)
