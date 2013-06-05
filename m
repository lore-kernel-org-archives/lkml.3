Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3FEHoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:44:17 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37743 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FEHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:44:16 -0400
Date: Wed, 5 Jun 2013 00:44:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paul.mckenney@us.ibm.com>
Subject: Re: [PATCH] Generic percpu refcounting
Message-ID: <20130605074412.GE7303@mtj.dyndns.org>
References: <1370039205-14071-1-git-send-email-koverstreet@google.com>
 <87d2s1rowi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2s1rowi.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 05:05:09PM +0930, Rusty Russell wrote:
> I think this should be rcu_read_lock(), which is currently equivalent
> but theoretically different.

I suggested using preempt_disable/enable() along with sched RCU.  I
thought that was better for some reason but I was probably
misremembering something.  rcu_read_lock/unlock() w/ synchronize_rcu()
should be fine too.  I don't care either way.

> Does your percpu_ref_kill() *really* need to be nonblocking?  (I'd have
> to read your other patches which use this to be sure).  Otherwise, just
> use synchronize_rcu(), and get rid of the release function...

synchronize_rcu() can always become problematic and should always be
avoided for generic things which may be used in various ways.  They
develop into very long latencies pretty quickly when chained back to
back.

Thanks.

-- 
tejun
