Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaKDPHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:07:30 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52870 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaKDPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:07:27 -0500
Message-ID: <1415113632.24819.4.camel@arm.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
From: Pawel Moll <pawel.moll@arm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Date: Tue, 04 Nov 2014 15:07:12 +0000
In-Reply-To: <CALCETrUAkXKyXzZy4xaYcW2f65Lh=APrU4cFU1zm-qmc6EwB8g@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
	 <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
	 <CALCETrUAkXKyXzZy4xaYcW2f65Lh=APrU4cFU1zm-qmc6EwB8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 01:25 +0000, Andy Lutomirski wrote:
> >> If you're going to add double-stamped packets, can you also add a
> >> syscall to read multiple clocks at once, atomically?  Or can you
> >> otherwise add a non-perf mechanism to get at this data?
> >
> > I've got some thoughts on what a possible interface that wouldn't be
> > awful could look like, but I'm still hesitant because I don't really
> > know if exposing this sort of data is actually a good idea long term.
> 
> My only real thought here is that, if perf is going to try to do this,
> then presumably it should be reasonably integrated w/ the core timing
> code.  I.e. if perf does this, then presumably the core code should
> know about it and there should be a core interface to it.

I think I understand where you're coming from. Arnd's idea for the API
seems reasonable, although I can't promise implementing a proposal
(don't make me stop you from doing it :-).

As to the perf-specific correlation, I'm assuming limited accuracy.
Others already mentioned that in the absence of hardware support, the
time values are never really "atomic". The best what can be done is to
access them as near to each other in the code as possible and make sure
it happens in a non-preemptible section. In my tests I've achieved, on
average, sub-microsecond accuracy, which was good enough from my
perspective, but it's far from ideal 42ns resolution for my (just an
example) time source clocked at 24MHz.

Paweł

