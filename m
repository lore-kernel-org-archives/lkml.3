Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3CKVBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:01:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab3CKVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:35 -0400
Date: Mon, 11 Mar 2013 14:01:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>,
        luis.henriques@canonical.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + signal-always-clear-sa_restorer-on-execve.patch added to -mm
 tree
Message-Id: <20130311140130.7effd02d12236dff081646d5@linux-foundation.org>
In-Reply-To: <CAGXu5jLcP1-6NpoSqi1kS+ShKwpTUkpLv6BsW6w39cpt9vKSxA@mail.gmail.com>
References: <20130311202255.942745A4121@corp2gmr1-2.hot.corp.google.com>
	<CAGXu5jLcP1-6NpoSqi1kS+ShKwpTUkpLv6BsW6w39cpt9vKSxA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 13:37:53 -0700 Kees Cook <keescook@chromium.org> wrote:

> ...
>

(pop toasting undone)

> > Subject: signal: always clear sa_restorer on execve
> >
> > When the new signal handlers are set up, the location of sa_restorer is
> > not cleared, leaking a parent process's address space location to
> > children.  This allows for a potential bypass of the parent's ASLR by
> > examining the sa_restorer value returned when calling sigaction().
> >
> > Based on what should be considered "secret" about addresses, it only
> > matters across the exec not the fork (since the VMAs haven't changed until
> > the exec).  But since exec sets SIG_DFL and keeps sa_restorer, this is
> > where it should be fixed.
>
> A note for backporters: you'll likely want to change
> __ARCH_HAS_SA_RESTORER to SA_RESTORER, since the former was recently
> introduced. If not, this will apply but not actually do any good.

I added this to the changelog, but I fear people won't read it!  Is
there any clever way in which we can have one patch which will work OK
in both old and new kernels?  I can't think of one...
