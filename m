Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3COUpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab3COUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:45:40 -0400
Message-ID: <1363380330.10054.0.camel@localhost>
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp
 filters.
From: Eric Paris <eparis@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Nicolas Schichan <nschichan@freebox.fr>, Will Drewry <wad@chromium.org>,
        Mircea Gherzan <mgherzan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 15 Mar 2013 16:45:30 -0400
In-Reply-To: <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr>
	 <1363372123-8861-2-git-send-email-nschichan@freebox.fr>
	 <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 11:45 -0700, Kees Cook wrote:
> On Fri, Mar 15, 2013 at 11:28 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:

> > diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> > index 6f19cfd..af27494 100644
> > --- a/include/linux/seccomp.h
> > +++ b/include/linux/seccomp.h
> > @@ -6,6 +6,7 @@
> >  #ifdef CONFIG_SECCOMP
> >
> >  #include <linux/thread_info.h>
> > +#include <linux/filter.h>
> >  #include <asm/seccomp.h>
> >
> >  struct seccomp_filter;
> > @@ -47,6 +48,44 @@ static inline int seccomp_mode(struct seccomp *s)
> >         return s->mode;
> >  }
> >
> > +/**
> > + * struct seccomp_filter - container for seccomp BPF programs
> > + *
> > + * @usage: reference count to manage the object lifetime.
> > + *         get/put helpers should be used when accessing an instance
> > + *         outside of a lifetime-guarded section.  In general, this
> > + *         is only needed for handling filters shared across tasks.
> > + * @prev: points to a previously installed, or inherited, filter
> > + * @len: the number of instructions in the program
> > + * @insns: the BPF program instructions to evaluate
> 
> This should be updated to include the new bpf_func field.
> 
> Regardless, it'd be better to not expose this structure to userspace.

This is fine....

include/uapi/linux/seccomp.h is exposed to userspace
include/linux/seccomp.h is  kernel internal

-Eric

