Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaHWQBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 12:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaHWQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 12:01:20 -0400
Date: Sat, 23 Aug 2014 17:58:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/shm: fix the historical/wrong mm->start_stack
	check
Message-ID: <20140823155832.GA9406@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com> <20140823152240.GH25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823152240.GH25918@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Cyrill Gorcunov wrote:
>
> On Sat, Aug 23, 2014 at 04:43:27PM +0200, Oleg Nesterov wrote:
> > The ->start_stack check in do_shmat() looks ugly and simply wrong.
> >
> > 1. ->start_stack is only valid right after exec(), the application
> >    can switch to another stack and even unmap this area.
> >
> > 2. The reason for this check is not clear at all. The application
> >    should know what it does. And why 4 pages? And why in fact it
> >    requires 5 pages?
> >
> > 3. This wrongly assumes that the stack can only grown down.
> >
> > Personally I think we should simply kill this check, but I did not
> > dare to do this. So the patch only fixes the 1st problem (mostly to
> > avoid the usage of mm->start_stack) and ignores VM_GROWSUP.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks!

> I don't understand this check either, the comment above it says nothing
> but only commits what code is doing not explaining why.

Yes, and this check predates the git history. I even looked into
git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git but this
change was added by the huge "v2.5.0.7 -> v2.5.0.8" update in 2002,
and obviously without any explanation (apart from "fix up proper shmat
semantics", but this connects SHM_REMAP itself).

Oleg.

