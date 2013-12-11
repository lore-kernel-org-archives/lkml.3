Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3LKMpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:45:23 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47644 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3LKMpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:45:20 -0500
Date: Wed, 11 Dec 2013 13:45:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211124514.GB1894@gmail.com>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
 <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
 <20131210213201.GF27373@redhat.com>
 <CA+55aFzkoqH5d3Ya9adqdmgZgZEsuZqTFfevor5k6M99HMF9=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzkoqH5d3Ya9adqdmgZgZEsuZqTFfevor5k6M99HMF9=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 10, 2013 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > http://www.codemonkey.org.uk/junk/perf.data.xz
> 
>  "Forbidden
> 
>   You don't have permission to access /junk/perf.data.xz on this server."
> 
> also, we'd need the vmlinux file to actually decode the data, I think.

So my point is somewhat moot in light of a fix patch, but the best way 
to export all interesting data is via running 'perf archive' after the 
perf.data got created:

  comet:~/tip> perf archive
  Now please run:

  $ tar xvf perf.data.tar.bz2 -C ~/.debug

  wherever you need to run 'perf report' on.
  comet:~/tip> 

and copying over both the perf.data and the perf.data.tar.bz2.

Arnaldo, I think we should make it even easier and more obvious to 
export/import perf data, via something like:

   perf clean              # cleans out ~/.debug
   perf record ...
   perf export             # creates perf.data.tar.bz2 which includes perf.data as well, not just .debug

and then whoever gets a perf.data.tar.bz2 can do:

   perf import             # does 'tar xjvf perf.data.tar.bz2'
   perf report             # analyze the data as if it was captured on your own box

which extracts it into the local directory. This makes the whole thing 
rather easy and makes the result complete and trustable.

What do you think?

Thanks,

	Ingo
