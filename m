Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbaHYSxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:53:33 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35969 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaHYSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:53:32 -0400
Date: Mon, 25 Aug 2014 11:51:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
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
In-Reply-To: <20140825171820.GB8338@redhat.com>
Message-ID: <alpine.LSU.2.11.1408251135540.24957@eggly.anvils>
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com> <20140823152240.GH25918@moon> <20140823155832.GA9406@redhat.com> <alpine.LSU.2.11.1408241818530.8474@eggly.anvils> <20140825150301.GB3021@redhat.com>
 <alpine.LSU.2.11.1408250856020.24245@eggly.anvils> <20140825171820.GB8338@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Oleg Nesterov wrote:
> On 08/25, Hugh Dickins wrote:
> 
> > And I think I'll let Linus's guard page justify your 4 (to match comment)
> > in place of the original's mysterious 5.
> 
> Ah, thanks again. Yes, if we want to guarantee 4 pages we should check 5.
> 
> Although obviously this doesn't explain the original's 5, this was
> written before check_stack_guard_page().

I meant, you changed the coded 5 to 4, to match the comment above it;
and if I were insistent on maximizing back-compatible-safety, I would
say that 4 should go back to 5; but since Linus added the guard page
gap at next->vm_start in between, I don't mind if you stick with 4
there to match the comment.

Disclaimer: I may be mistaken in each clause of that paragraph,
and you may prefer to ignore everything I wrote there as worthless!
But I didn't understand your "to guarantee 4 we should check 5".

Hugh
