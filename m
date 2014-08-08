Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaHHBSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:18:42 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:44744 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaHHBSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:18:41 -0400
Message-ID: <1407460714.2513.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Date: Thu, 07 Aug 2014 18:18:34 -0700
In-Reply-To: <1407260539.6493.3.camel@buesod1.americas.hpqcorp.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
	 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
	 <20140625062510.GB4260@osiris>
	 <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
	 <1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>
	 <CAMuHMdX2ZCEd=J_Gpf-W+Zyqg27r4C6ULZgO=pg2houR-FXLvg@mail.gmail.com>
	 <1407260539.6493.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 10:42 -0700, Davidlohr Bueso wrote:
> On Tue, 2014-08-05 at 15:04 +0200, Geert Uytterhoeven wrote:
> > It looks like you forgot to update frv?  It's been failing on -next since a
> > few days:

Anyway developers can be alerted sooner about this (ie: while its still
in -next phase), like automated emails or something? This would be extra
nice for those archs that are harder to get tested.

> > kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> > function 'cpu_relax_lowlatency'
> > [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> > kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> > function 'cpu_relax_lowlatency'
> > [-Werror=implicit-function-declaration]
> > make[3]: *** [kernel/locking/mcs_spinlock.o] Error 1
> > cc1: some warnings being treated as errors
> > make[3]: *** [kernel/locking/mutex.o] Error 1
> > 
> > http://kisskb.ellerman.id.au/kisskb/buildresult/11616307/
> 
> Ah, indeed. Thanks for the report, afaict this was the only missing
> arch .

Adding Guenter who also reported this yesterday.

Linus, since this is build-breaking an entire arch, it might be worth
avoiding the whole -tip thing and get the fix in as soon as possible.

Thanks,
Davidlohr

