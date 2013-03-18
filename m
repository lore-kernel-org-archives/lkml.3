Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3CRPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:16:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55696 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3CRPQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:16:58 -0400
Date: Mon, 18 Mar 2013 16:16:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
Message-ID: <20130318151646.GB8879@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Borislav Petkov <bp@suse.de>, Robert Richter <rric@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <20130318084008.GA17959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130318084008.GA17959@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:40:08AM +0100, Ingo Molnar wrote:
> That definitely looks interesting and desirable. It would be nice to
> have more generic/flexible semantics by using the VFS for tracing
> context discovery.
>
> That would allow 'stateful tracing', and not just in a kernel
> initiated fashion: we could basically do ftrace-alike tracing, into
> persistent, VFS-named buffers.
>
> The question is, how are the individual buffers identified when and
> after they have been created? An option would be to use cgroups for
> that - cgroups already has its own VFS and syscall interfaces. But
> maybe some other, explicit interface is needed (eventfs).

My latest knowledge is that Steve needs an events filesystem too because
he wants to do mkdir in debugfs. So maybe we should really do an eventfs
finally - it has been asked for for so many times now. :)

> All the usecases we talked about in the past would work fine that way:
>
>  - the MCE events would show up as an already created set of buffers,
>  discoverable via the VFS interface.

Right, in the MCE case though, we want to enable them as early as
possible, i.e. long before we can even manipulate something through the
VFS. So my current thinking is that we need both - a way to enable a
persistent event from within the kernel and then the eventfs thing.

>  - user-space could generate more 'tracing/profiling contexts' runtime.

Sure.

>  - a boot tracer would activate via a boot option, and it would create
>  a tracing context - visible via the VFS interface.

Right, and this one you still want to enable as early as possible, long
before userspace can access something through VFS. Btw, how are we going
to boottrace stuff which happens before perf initialization? Cache it
into buffers somewhere?

>  - modern RAS daemon replacing mcelog
>
> If you make that work, via a new perf tool side as well that allows
> the creation of a tracing context (and a separate extraction as well),
> via modified 'perf trace' or a new subcommand, that would be an major,
> upstream-worthy perf feature IMO which would go way beyond the RAS
> usecase.

Right, ok, so we could start working towards that too but I'd like to
not delay the persistent events stuff so that we can finally do the RAS
daemon, and do it properly.

Besides, having the eventfs and persistency would be a different aspect
to manipulating perf events and can be developed independently and in
parallel.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
