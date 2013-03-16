Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3CPSBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:01:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41872 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3CPSBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:01:45 -0400
Date: Sat, 16 Mar 2013 18:01:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
Message-ID: <20130316180141.GB21522@ZenIV.linux.org.uk>
References: <1363441844.2023.17.camel@joe-AO722>
 <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
 <1363456278.2023.40.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363456278.2023.40.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 10:51:18AM -0700, Joe Perches wrote:
> > This is certainly a neat trick.
> > 
> > But I don't really like the fact that it complicates things for every
> > future code reader, especially when a trivial change in the caller
> > would accomplish the same thing.  Do you have any idea how much
> > performance we would gain in exchange for the complication?
> 
> Nope.  I believe it's trivial in any case.
> I just saw Steven's trace hack and thought of seq_printk.
> 
> Is there a real performance sensitive seq_printf anywhere?

... and _that_ is the question that should've been asked first.

> It's trivial to replace seq_printf("constant") with
> seq_puts but there are over a thousand of them.
> 
> It may be better to just leave everything as-is.

Quite.  Note that it's not equivalent to gcc treatment of printf/puts -
there we have cases when it *is* a real hotpath (and I seriously suspect
that it's in part driven by desire to discourage people from uglifying
source by manual equivalents of that micro-optimization).  Moreover,
glibc printf at least used to be heavy; kernel-side we are nowhere near
that bad.
