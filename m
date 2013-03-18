Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3CRU7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:59:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3CRU7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:59:51 -0400
Date: Mon, 18 Mar 2013 13:59:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
Message-Id: <20130318135949.853ef457d0334008d83ae80f@linux-foundation.org>
In-Reply-To: <20130316175446.GA21522@ZenIV.linux.org.uk>
References: <1363441844.2023.17.camel@joe-AO722>
	<20130316175446.GA21522@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 17:54:47 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, Mar 16, 2013 at 06:50:44AM -0700, Joe Perches wrote:
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
> Joe, would you mind showing me a single real-world case where that
> "optimization" would really matter?

There's also a small reduction in code footprint.  We merge less
significant things all day ;)

> NAKed-because: GAFL

Yeah, that macro thing should be nuked from orbit.  Please let's add the
checkpatch rule (resend when convenient with clean changelog, please)
and if people want to send "convert seq_printk to seq_puts" patches to
Jan and he takes them into the trivial tree then all is good.
