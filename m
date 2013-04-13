Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3DMQNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 12:13:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3DMQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 12:13:46 -0400
Date: Sat, 13 Apr 2013 18:10:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 6/9] uretprobes: Return probe exit, invoke handlers
Message-ID: <20130413161051.GA6803@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com> <1365004839-21982-7-git-send-email-anton@redhat.com> <20130407105308.GA2899@linux.vnet.ibm.com> <20130409140530.GA20577@redhat.com> <20130409201302.GA30570@redhat.com> <20130413100113.GC11721@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413100113.GC11721@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Srikar Dronamraju wrote:
>
> > > Oh yes, this should be documented more explicitly in the changelog of
> > > this patch or 7/9 (which tries to document the limitations but should
> > > be more clear).
> > >
> > > Currently we do not support longjmp() and we assume that the probed
> > > function should do the regular return. We should certainly try to improve
> > > this, but I really think that this should go into the next series.
> > >
> > > Because this is nontrivial, needs more discussion, and I'm afraid should
> > > be per-arch. Even on x86 (which can check the stack) this is not simple,
> > > in general we can't know how to check that (to simplify) the first frame
> > > is already invalid. Just for example, we could check regs->sp and detect
> > > that longjmp() was called but sigaltstack() can easily fool this logic.
> > >
>
> Yes, its perfectly fine to keep this logic for the next patchset.

OK, great.

> Can you tell me why sigaltstack() can fool us if we rely on regs->sp.

Because we can't simply compare resg->sp and ret_instance->sp and decide
if we should ignore this ri or not, the task can hit retprobe, then take
a signal, switch to altstack and hit another rp. I'll write another email
(hopefully patches) later.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks Srikar.

OK. Everything is acked, I'll send git-pull-request.

Oleg.

