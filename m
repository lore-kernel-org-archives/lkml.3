Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaBXPvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:51:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbaBXPvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:51:39 -0500
Date: Mon, 24 Feb 2014 16:51:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kill the racy EXIT_ZOMBIE->EXIT_DEAD->EXIT_ZOMBIE
	transition
Message-ID: <20140224155121.GA10545@redhat.com>
References: <20140220173838.GA21825@redhat.com> <20140220194848.GA6573@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220194848.GA6573@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Tejun Heo wrote:
>
> On Thu, Feb 20, 2014 at 06:38:38PM +0100, Oleg Nesterov wrote:
> > Tejun, unless I missed something WSTOPPED logic is broken if a process
> > has a zombie/ptraced leader, "A zombie ptracee is only visible to its
> > ptracer" is wrong in this case. Plus perhaps some cleanups make sense.
>
> Heh, I already forgot most details about ptrace. :)

This is mostly about do_wait(), although yes, !ptrace case looks fine.
And it turns out, I forgot these details too.

> Is it something
> urgent?

No, please forget. But it seems that wait_consider_task(zombie_leader)
is very wrong wrt zombie leaders. WSTOPPED is simple, but I am still
trying to find a simple fix for other problems. And the main problem,
of course, is that this API is broken and we can't fix it.

Oleg.

