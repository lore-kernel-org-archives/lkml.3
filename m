Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab3D3RDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab3D3RDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:03:35 -0400
Date: Tue, 30 Apr 2013 19:00:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 09/10] sigtimedwait: use freezable blocking call
Message-ID: <20130430170027.GA28380@redhat.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com> <1367271946-7239-10-git-send-email-ccross@android.com> <20130430163817.GA27304@redhat.com> <CAMbhsRTABgbWgFca03nVWVmVeK5Ci9BPon-zQwanM16LrN=fog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTABgbWgFca03nVWVmVeK5Ci9BPon-zQwanM16LrN=fog@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Colin Cross wrote:
> On Tue, Apr 30, 2013 at 9:38 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 04/29, Colin Cross wrote:
> >>
> >> Avoid waking up every thread sleeping in a sigtimedwait call during
> >> suspend and resume by calling a freezable blocking call.
> >
> > This doesn't explain why do want this change...
> >
> > OK, probably to avoid -EAGAIN from sigtimedwait() if the freezer wakes
> > up the caller.
>
> See http://marc.info/?l=linux-pm&m=136727197819593&w=2 for the full
> justification.  I will include a fuller description of the reason for
> this patch in the next version.

Yes, thanks, I already realized what are you trying to do.

> > The task will be interrupted anyway and the syscall will return
> > -EAGAIN, this only changes the time when try_to_freeze() is called.
> >
> > For what? The task will call do_signal/try_to_freeze really "soon".
>
> See http://marc.info/?l=linux-pm&m=136727204919622&w=2, which removes
> the wakeup sent to skipped tasks, so schedule_timeout_interruptible()
> will only return if the timeout finishes or another task

Or if freeze_task() was already called.

but I guess you do not care.

Oleg.

