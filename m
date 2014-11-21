Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKUSYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:39 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38658 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaKUSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141121123434.279c5613@gandalf.local.home>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
	<CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
	<20141121170805.GD30603@home.goodmis.org>
	<CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
	<20141121123434.279c5613@gandalf.local.home>
Date: Fri, 21 Nov 2014 10:24:35 -0800
X-Google-Sender-Auth: 8WyI7v_7HJEGIQwWBKS7eNNTyms
Message-ID: <CA+55aFwYCYoU5t1GU4i=1w5-5HzPfLb42MLANq6ghViSSenxsA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 9:34 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I see. You have issues with the use of current->active_mm instead of
> just doing a read_cr3() (and I'm sure other things).

Yes. And I have this memory of it actually mattering, where we'd get
get the page fault, but see that the (wrong) page table is already
populated, and say "ti wasn't a vmalloc fault", and then go down the
oops path.

Of course, the context switch itself has changed completely over the
years, but I think it would still be true with NMI. "active_mm" may
point to a different page table than the one the CPU is actually
using, and then the whole thing is bogus.

               Linus
