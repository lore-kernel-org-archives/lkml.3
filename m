Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaKXVuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:50:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaKXVuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:50:00 -0500
Date: Mon, 24 Nov 2014 22:49:40 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        nick <xerofoify@gmail.com>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141124214939.GA6671@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
 <54730475.9040000@redhat.com>
 <54730B33.1080101@siemens.com>
 <20141124210000.GB6795@potion.brq.redhat.com>
 <20141124161901.6266925c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141124161901.6266925c@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-24 16:19-0500, Steven Rostedt:
> On Mon, 24 Nov 2014 22:00:01 +0100
> Radim Krčmář <rkrcmar@redhat.com> wrote:
> 
> > 2014-11-24 11:40+0100, Jan Kiszka:
> > The format string has to be a string literal[1]; we could change it to
> > allow expressions[2], but what we want is almost possible through a
> > direct call to trace_seq_printf()[3].
> > 
> > The raw result would look like
> > 
> >   #define __print(fmt, args...) ({ \
> >   	const char *buf_start = trace_seq_buffer_ptr(p); \
> >   	trace_seq_printf(p, fmt, args); \
> >   	trace_seq_putc(p, '\0'); \
> >   	buf_start; \
> >   	})
> > 
> >   TP_printk("%s%s", [...],
> >             __entry->has_error ? __print("(0x%x)", __entry->error_code) : "")
> > 
> > and would be acceptable if something __print-like made it into a ftrace
> > helper[4].  (Userspace won't be able to nicely print it otherwise.)
> 
> You mean if we add something like a __print_conditional(cond, fmt, ...);

The benefit of _conditional is cleaner code?

(_conditional would be possible as a #define on top of generic print,
 the ternary seems to be parsed correctly.)

> For this case you would have:
> 
>   TP_printk("%s%s", [...],
> 	__print_conditional(__entry->has_error, " (0x%x)", __entry->error_code));
> 
> Where __print_conditional() will return "" when "cond" is false, and
> will return the formatted string otherwise.

(This might introduce 'const char empty[] = ""'.)

> That wouldn't be too hard to implement.

I'll look at the patch tommorrow.

Thanks.
