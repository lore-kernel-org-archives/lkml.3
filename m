Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaAKSSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKSSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:18:48 -0500
Date: Sat, 11 Jan 2014 19:19:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140111181908.GA7358@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com> <20140110153459.GA31491@redhat.com> <20140111063438.GY10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111063438.GY10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Paul E. McKenney wrote:
>
> On Fri, Jan 10, 2014 at 04:34:59PM +0100, Oleg Nesterov wrote:
> >
> > doesn't this look much simpler than adding the "bool unshared" argument
> > and changing the callers?
>
> I might be being too paranoid, but my concern with using rcu_lock_acquire()
> and rcu_lock_release()

And I agree, I no longer suggest to use rcu_lock_acquire/release.

It seems that you misunderstood me, let me send v2 for review.

Oleg.

 fs/file.c                |   30 +++++++++++-------------------
 include/linux/fdtable.h  |   35 +++++++++++++++++++++--------------
 include/linux/rcupdate.h |    2 --
 kernel/rcu/update.c      |   11 -----------
 4 files changed, 32 insertions(+), 46 deletions(-)

