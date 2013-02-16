Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab3BPAjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:39:33 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:37039 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3BPAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130216000435.GY4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
From: Shentino <shentino@gmail.com>
Date: Fri, 15 Feb 2013 16:38:51 -0800
Message-ID: <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> How would you manage to have it masked at that point?  setup_new_exec()
> is inevitable after success of flush_old_exec() and it will do
> flush_signal_handlers() for us.

I wouldn't know for sure but I read somewhere that even if execve
resets handled signals, it didn't also say that ignored signals were
also reset.  (Source: execve man page.)

Plus I've always seen "force_sig" instead of "send_sig" for errors
that can't just be ignored.

Then again I'm a complete n00b at linux hacking so I could very well
be mistaken.  It just looked funny considering what I'm used to seeing
in the source.

I'm hoping this is just me being an idiot and that there's nothing to
worry about.

> And yes, flush_old_exec() and setup_new_exec() ought to be merged; the
> problem with that is the stuff done between those two - setting personality,
> plus playing with thread flags if needed.  Unfortunately, there are non-obvious
> differences between architectures, so that would have to be hashed out on
> linux-arch.  Doesn't affect the point above, though...
