Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaDAVmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:42:19 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47219 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaDAVmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
 <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net> <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
 <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net> <20140331170546.3b3e72f0.akpm@linux-foundation.org>
 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 Apr 2014 17:41:54 -0400
Message-ID: <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Hmmm so 0 won't really work because it could be weirdly used to disable
>> > shm altogether... we cannot go to some negative value either since we're
>> > dealing with unsigned, and cutting the range in half could also hurt
>> > users that set the limit above that. So I was thinking of simply setting
>> > SHMMAX to ULONG_MAX and be done with it. Users can then set it manually
>> > if they want a smaller value.
>> >
>> > Makes sense?
>>
>> I don't think people use 0 for disabling. but ULONG_MAX make sense to me too.
>
> Distros could have set it to [U]LONG_MAX in initscripts ten years ago
> - less phone calls, happier customers.  And they could do so today.
>
> But they haven't.   What are the risks of doing this?

I have no idea really. But at least I'm sure current default is much worse.

1. Solaris changed the default to total-memory/4 since Solaris 10 for DB.
 http://www.postgresql.org/docs/9.1/static/kernel-resources.html

2. RHEL changed the default to very big size since RHEL5 (now it is
64GB). Even tough many box don't have 64GB memory at that time.
