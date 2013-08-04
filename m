Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3HDOyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab3HDOyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:54:15 -0400
Date: Sun, 4 Aug 2013 16:48:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] exec: move allow_write_access/fput to exec_binprm()
Message-ID: <20130804144847.GB18906@redhat.com>
References: <20130802192713.GA9543@redhat.com> <20130802192734.GA9565@redhat.com> <CAGXu5jKY1S7wxWCv6ZULU=rvp1fQ9KemcFZxY7ccoX06jdvP3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKY1S7wxWCv6ZULU=rvp1fQ9KemcFZxY7ccoX06jdvP3w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Kees Cook wrote:
>
> On Fri, Aug 2, 2013 at 12:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > @@ -1455,6 +1451,11 @@ static int exec_binprm(struct linux_binprm *bprm)
> >                 ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
> >                 current->did_exec = 1;
> >                 proc_exec_connector(current);
> > +
> > +               if (bprm->file) {
> > +                       allow_write_access(bprm->file);
> > +                       fput(bprm->file);
> > +               }
>
> Why not keep the bprm->file = NULL assignment?

Because it is no longer needed.

And now that we have the non-recursive exec_binprm() called right
before free_bprm() it is obvious that it won't be used again.

> Seems reasonable to
> keep that just to be avoid use-after-free accidents.

OK. I will add it back. With the comment to explain that this is
only to catch the possible problems.

I guess it would be better if I resend the whole series to avoid
the confusion. I am going to add your acks. It seems that you acked
everything except 1/3 in the previous series, perhaps you can ack
it too?

Thanks for review!

Oleg.

