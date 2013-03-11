Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3CKTkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:40:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3CKTkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:40:37 -0400
Date: Mon, 11 Mar 2013 20:38:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] signal: always clear sa_restorer on execve
Message-ID: <20130311193841.GA20556@redhat.com>
References: <20130311191156.GA17763@www.outflux.net> <20130311192805.GA19428@redhat.com> <CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Kees Cook wrote:
> On Mon, Mar 11, 2013 at 12:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 03/11, Kees Cook wrote:
> >>
> >> When the new signal handlers are set up for a fork, the location of
> >> sa_restorer is not cleared, leaking a parent process's address space
> >> location to children. This allows for a potential bypass of the parent's
> >> ASLR by examining the sa_restorer value returned when calling sigaction().
> >
> > I don't understand.
> >
> > fork() should not change restorer/etc, and the child has the same address
> > space anyway. There is no any leak and the patch can't make any difference
> > in this case because flush_signal_handlers() is not called by fork().
>
> I probably failed to explain this correctly. From the perspective of
> what should be considered "secret", it only matters across the exec,
> not the fork (since the VMAs haven't changed until the exec).

Exactly. So may be you should update the changelog? It really looks
as if the parent should "hide" something from the forked child.

> But the
> info leak is easy to see, and this patch fixes it. As you say, since
> other things were reset, so should sa_restorer.

Yes, I didn't argue with the patch itself.

Oleg.

