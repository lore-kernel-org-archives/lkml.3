Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaK0Bai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:30:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbaK0Bah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:30:37 -0500
Date: Thu, 27 Nov 2014 02:30:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
Message-ID: <20141127013022.GA3476@redhat.com>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box> <20141125010734.4974.85347.stgit@pluto.fritz.box> <20141125215248.GA7958@redhat.com> <1416954967.2509.25.camel@pluto.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416954967.2509.25.camel@pluto.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't have time to follow this thread today, will try tomorrow.
Perhaps this was already answered...

On 11/26, Ian Kent wrote:
>
> On Tue, 2014-11-25 at 22:52 +0100, Oleg Nesterov wrote:
> >
> > and probably we also need this for coredump helpers, we want them
> > to be per-namespace.
>
> To save me some time could you point me to some of the related code
> please. I don't normally play in that area.

See call_usermodehelper_*() in do_coredump(). This has the same problems
(and just in case, of course other problems, starting from the fact that
core_pattern is global). We need the right root to find the binary, etc.

> > > +	switch_task_namespaces(current, ns);
> >
> > This doesn't look sane because this won't switch task_active_pid_ns().
>
> I wondered about that too but I didn't design the open()/setns()

No, I don't think we should use setns() in this case...

> > And otoh. If we actually want to use the caller's mnt_ns/namespaces we
> > could simply fork/reparent a child which will do execve ?
>
> Are you saying that the user space program should be modified to do
> this?

No, no, I meant that the kernel could do this (yes, not that trivial)
on behalf of the caller's process.

Oleg.

