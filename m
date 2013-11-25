Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3KYOeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:34:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab3KYOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:34:15 -0500
Date: Mon, 25 Nov 2013 15:35:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: Introduce "pseudo registers" for
	FETCH_MTD_reg
Message-ID: <20131125143521.GA29815@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131123201605.GB22148@redhat.com> <5291ABA5.7030505@hitachi.com> <877gbwsy8w.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gbwsy8w.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Namhyung Kim wrote:
>
> On Sun, 24 Nov 2013 16:32:53 +0900, Masami Hiramatsu wrote:
> > (2013/11/24 5:16), Oleg Nesterov wrote:
> >
> >> This syntax is %%pseudo-reg-name, I agree in advance with any other
> >> naming.
> >
> > For this kind of use, kprobe-tracer already provides '$' prefix :)
> > e.g. $stack, $retval etc. Please see parse_probe_vars in trace_probe.c.
> >
> > So, $current and $cpu is better for me.
>
> Agreed.

OK, thanks, I'll redo.

But I hope you will agree with overloading of FETCH_MTD_reg, I do not
want to add yet another method.



In fact I thought about $current too, and I agree it looks better. But
this conflicts with other changes I had in mind. I was going to add the
support for @symbol+%reg and +%reg(...), then add the %%percpu_shift
pseudo reg. But on a second thought this doesn't look very nice, so
lets use $name.

Oleg.

