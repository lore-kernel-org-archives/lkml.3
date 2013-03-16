Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3CPRvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:51:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38526 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752089Ab3CPRvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:51:19 -0400
Message-ID: <1363456278.2023.40.camel@joe-AO722>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 10:51:18 -0700
In-Reply-To: <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
References: <1363441844.2023.17.camel@joe-AO722>
	 <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 09:43 -0600, Bjorn Helgaas wrote:
> On Sat, Mar 16, 2013 at 7:50 AM, Joe Perches <joe@perches.com> wrote:
> > Instead of converting the 800 or so uses of seq_printf with
> > a constant format (without a % substitution) to seq_puts,
> > maybe there's another way to slightly speed up these outputs.
> >
> > Taking a similar approach to commit abd84d60eb
> > ("tracing: Optimize trace_printk() with one arg to use trace_puts()")
> > use the preprocessor to convert seq_printf(seq, "string constant")
> > to seq_puts(seq, "string constant")
> >
> > By stringifying __VA_ARGS__, we can, at compile time, determine
> > the number of args that are being passed to seq_printf() and
> > call seq_puts or seq_printf appropriately.
> >
> > The actual function definition for seq_printf must now
> > be enclosed in parenthesis to avoid further macro expansion.
> 
> This is certainly a neat trick.
> 
> But I don't really like the fact that it complicates things for every
> future code reader, especially when a trivial change in the caller
> would accomplish the same thing.  Do you have any idea how much
> performance we would gain in exchange for the complication?

Nope.  I believe it's trivial in any case.
I just saw Steven's trace hack and thought of seq_printk.

Is there a real performance sensitive seq_printf anywhere?

It's trivial to replace seq_printf("constant") with
seq_puts but there are over a thousand of them.

It may be better to just leave everything as-is.

