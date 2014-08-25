Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaHYRVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbaHYRVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:21:10 -0400
Date: Mon, 25 Aug 2014 19:18:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20140825171820.GB8338@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com> <20140823152240.GH25918@moon> <20140823155832.GA9406@redhat.com> <alpine.LSU.2.11.1408241818530.8474@eggly.anvils> <20140825150301.GB3021@redhat.com> <alpine.LSU.2.11.1408250856020.24245@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408250856020.24245@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Hugh Dickins wrote:
>
> On Mon, 25 Aug 2014, Oleg Nesterov wrote:
> > On 08/24, Hugh Dickins wrote:
> > >
> > > I'd say it comes earlier, from Christoph Rohland's 2.4.17-pre7's
> > > "Add missing checks on shmat()", though I didn't find more than that.
> > >
> > > We can all understand wanting to leave a gap below the growsdown stack,
> > > but of course could argue about growsup and 1 or 4 or 5 or whatever:
> >
> > And it is not clear to me why the kernel should care at all,
>
> Care about what exactly?  Leaving a gap between shm and stack?
>
> The man page says that (unless SHM_REMAP) shmat() will fail with
> EINVAL if a mapping already exists there, and I think it's fair
> to regard the vm_start of a VM_GROWSDOWN somewhat elastically.
>
> It may be that Linus's check_stack_guard_page() work in 2.6.36
> changed the importance of this shmat() check, but I'd still feel
> safer to leave it as is (while turning a blind eye to the
> VM_GROWSUP omission).
>
> >
> > > okay that we're all more interested in just removing that start_stack.
> >
> > so perhaps v2 should simply remove it? Or do you think it would be safer
> > to not do this?
>
> It would be safer to leave it, but replace the start_stack use as you did.

OK, thanks.

> And I think I'll let Linus's guard page justify your 4 (to match comment)
> in place of the original's mysterious 5.

Ah, thanks again. Yes, if we want to guarantee 4 pages we should check 5.

Although obviously this doesn't explain the original's 5, this was
written before check_stack_guard_page().

OK.

Oleg.

