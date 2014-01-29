Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaA2P6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:58:09 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:53058 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbaA2P6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:58:07 -0500
Date: Wed, 29 Jan 2014 09:58:04 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Rientjes <rientjes@google.com>
cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1401290957350.23856@nuc>
References: <20140128183808.GB9315@linux.vnet.ibm.com> <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, David Rientjes wrote:

> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index b5ae3ee..8573e4e 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct *tsk)
> >  	if (tsk == kthreadd_task)
> >  		return tsk->pref_node_fork;
> >  #endif
> > -	return numa_node_id();
> > +	return numa_mem_id();
>
> I'm wondering why return NUMA_NO_NODE wouldn't have the same effect and
> prefer the local node?
>

The idea here seems to be that the allocation may occur from a cpu that is
different from where the process will run later on.

