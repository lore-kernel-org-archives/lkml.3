Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaK1AUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:20:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaK1AUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:20:02 -0500
Message-ID: <1417133990.2520.15.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 28 Nov 2014 08:19:50 +0800
In-Reply-To: <87egsq6etz.fsf@x220.int.ebiederm.org>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com>
	 <1416954967.2509.25.camel@pluto.fritz.box>
	 <87egsq6etz.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 17:27 -0600, Eric W. Biederman wrote:
> 
> > How does one correctly set the namespace in user space since each of
> > the /proc/<pid>/ns/<namespace> will use a slightly different
> > proc_ns_operations install function? 
> >
> > Are we saying that, for example, if open(/proc/<pid>/ns/pid)/setns() is
> > used then the process must not do path lookups if it expects them to be
> > within the namespace and restrict itself to pid related system calls
> > only and so on for each of the other namespaces?
> 
> In userspace you can only set the pid namespace for new children.  You
> can never change your own pid namespace.  Because actually changing a
> processes pid is too nasty to contemplate, or implement and because in a
> login daemon context having your first child be the initial process of
> the pid namespace is actually what is desirable.
> 

Maybe using the pid namespace was a bad example but now it seems I don't
understand the purpose of /proc/<pid>/ns/pid with the use of setns()
either.

I wasn't thinking of changing the process pid here at all, as you say
from the kernel POV that must not happen, I was thinking of changing an
execed userspace process view of pids.

Assuming that <pid> is valid within a callers namespace (and I believe
that's checked along the way) doesn't using this allow the created
userspace process to see pids in the view of the given namespace? Isn't
that the intended use of this?

Ian

