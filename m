Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaGAO5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaGAO5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:57:07 -0400
Date: Tue, 1 Jul 2014 16:55:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] rcu: uninline rcu_lock_acquire() and
	rcu_lock_release()
Message-ID: <20140701145523.GA12547@redhat.com>
References: <20140630161837.GA15873@redhat.com> <20140630202420.GG4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630202420.GG4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Paul E. McKenney wrote:
>
> On Mon, Jun 30, 2014 at 06:18:37PM +0200, Oleg Nesterov wrote:
> > Hello,
> >
> > May be correct this time ;) Based on paulmck/linux-rcu.git rcu/next.
> >
> > 2/2 is new and hopefully trivial. But! the numbers look suspiciously
> > good, I do not understand where does the difference come from...
>
> Probably from rcu_dereference_raw() and rcu_dereference_check(..., 1).  ;-)

Yes, sure, this was the motivation for the patch. But I didn't expect the
50k difference ;)

OK, I understand now. I forgot that every list_for_each_rcu/list_entry_rcu
has rcu_dereference_raw().

> Queued and kicked off testing, both mine and (indirectly) Fengguang's.

Thanks!

Oleg.

