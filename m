Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaKYRRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaKYRRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:17:42 -0500
Date: Tue, 25 Nov 2014 18:17:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] exit: reparent: fix/update the comments in
	zap_pid_ns_processes()
Message-ID: <20141125171732.GA29623@redhat.com>
References: <20141124200626.GA21006@redhat.com> <874mtodzhd.fsf@x220.int.ebiederm.org> <20141125165745.GB28913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125165745.GB28913@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 11/25, Oleg Nesterov wrote:
>
> On 11/24, Eric W. Biederman wrote:
> >
> > - We won't wait for an injected process in a pid namespace,
> >   or a processes debugged with gdb to be reaped before the pid
> >   init process exits if we don't wait.
>
> Yes, and I do not see why this is bad, but this is off-topic.
>
> Again, lets discuss this in another thread. This patch doesn't try to
> document the desired semantics, it only tries to explain why zap_pid_ns
> _has_ to wait until EXIT_DEAD (and in fact EXIT_ZOMBIE) tasks go away.

Just in case, as for "processes debugged with gdb" I obviously agree,
but this has nothing to do with EXIT_DEAD threads. zap_pid_ns_processes()
will sleep in sys_wait4() until debugger detaches the tracee and reaps
it due to ignored SIGCHLD.

But again, this is off-topic now.

> Eric. I'd really ask you to take another look. But in any case: thanks for
> looking at this.

Yes, please.

Oleg.

