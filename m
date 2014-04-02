Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030281AbaDBThR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:37:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030188AbaDBThP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:37:15 -0400
Date: Wed, 2 Apr 2014 15:37:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] x86: Fix perf deadlock caused by dumpstack cleanup
Message-ID: <20140402153713.18e3444e@gandalf.local.home>
In-Reply-To: <CA+55aFwzD0azkqLQLKz+9XOwDbY937z+Ym02diu91AZR7XT6Dw@mail.gmail.com>
References: <20140402172639.994587272@goodmis.org>
	<CA+55aFwzD0azkqLQLKz+9XOwDbY937z+Ym02diu91AZR7XT6Dw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 11:46:38 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Apr 2, 2014 at 10:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Here are two patches that fix the deadlock that you discovered.
> >
> > The first patch is the real culprit, but as I was looking at the code
> > I realized that the irq stack part was a bit off too. That part didn't
> > cause the lock up, but needs to be fixed regardless.
> >
> > Note, I'm hoping to use these clean ups to make x86_64 and i386 code
> > a bit closer to each other, so I hope the original change does not
> > get reverted.
> 
> I'll apply them.
> 
> That said, I'm not *AT*ALL* convinced that a "cleanup" that involves
> having helper functions with multiple bugs and now seven (7!)
> arguments passed into it is a "cleanup" at all.
> 

Yeah, I didn't like it after the second patch :-(

> The cleanup was claimed to help improve readability. Really? Somebody
> needs to reconsider their goals in life if they think that a
> 7-argument helper functions where the caller needs to pass in
> addresses to variables because the helper function will change them is
> a good idea. Just the *call* is spread out over two lines because
> calling that function is so complex.

The helper can be merged back to the main function as it doesn't seem
to be much of a helper anymore.

> 
> I suspect that maybe creating some kind of "struct stack_information"
> structure might help somewhat. Because right now I'm very doubtful
> about the whole "this clarifies/simplifies" argument. The very fact
> that the "cleaned-up" function was a buggy pile of sh*t should make
> you question the cleanup itself.

Well, actually, it proves that there's a clean up needed, as the reason
for the bugs was due to the subtle interactions of the original code.
That said, I agree, the cleanup itself isn't much of a cleanup. But I
intend on continuing to cleanup this code, and remove all the subtle
interactions that is going on here.

This is an ongoing project and what you see here is not the end result.
I am quite ashamed of the bugs though.

-- Steve

