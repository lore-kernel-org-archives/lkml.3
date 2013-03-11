Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3CKVUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:20:41 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49732 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3CKVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:20:38 -0400
Date: Mon, 11 Mar 2013 14:20:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Ben Hutchings <ben@decadent.org.uk>,
        luis.henriques@canonical.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + signal-always-clear-sa_restorer-on-execve.patch added to -mm
 tree
Message-ID: <20130311212034.GC32527@kroah.com>
References: <20130311202255.942745A4121@corp2gmr1-2.hot.corp.google.com>
 <CAGXu5jLcP1-6NpoSqi1kS+ShKwpTUkpLv6BsW6w39cpt9vKSxA@mail.gmail.com>
 <20130311140130.7effd02d12236dff081646d5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311140130.7effd02d12236dff081646d5@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:01:30PM -0700, Andrew Morton wrote:
> On Mon, 11 Mar 2013 13:37:53 -0700 Kees Cook <keescook@chromium.org> wrote:
> 
> > ...
> >
> 
> (pop toasting undone)
> 
> > > Subject: signal: always clear sa_restorer on execve
> > >
> > > When the new signal handlers are set up, the location of sa_restorer is
> > > not cleared, leaking a parent process's address space location to
> > > children.  This allows for a potential bypass of the parent's ASLR by
> > > examining the sa_restorer value returned when calling sigaction().
> > >
> > > Based on what should be considered "secret" about addresses, it only
> > > matters across the exec not the fork (since the VMAs haven't changed until
> > > the exec).  But since exec sets SIG_DFL and keeps sa_restorer, this is
> > > where it should be fixed.
> >
> > A note for backporters: you'll likely want to change
> > __ARCH_HAS_SA_RESTORER to SA_RESTORER, since the former was recently
> > introduced. If not, this will apply but not actually do any good.
> 
> I added this to the changelog, but I fear people won't read it!  Is
> there any clever way in which we can have one patch which will work OK
> in both old and new kernels?  I can't think of one...

I'll store it in my stable inbox and will hope to remember it when it
hits Linus's tree...

thanks,

greg k-h
