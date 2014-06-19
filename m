Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbaFSTGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:06:05 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:45657 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbaFSTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:06:03 -0400
Date: Thu, 19 Jun 2014 15:06:00 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140619190600.GA7390@mtj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <53A1097F.3060400@cn.fujitsu.com>
 <20140618153222.GA11042@htj.dyndns.org>
 <53A243B8.4010501@cn.fujitsu.com>
 <20140619020727.GC20100@mtj.dyndns.org>
 <20140619022708.GB4669@linux.vnet.ibm.com>
 <20140619133624.GI11042@htj.dyndns.org>
 <20140619170549.GC4904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619170549.GC4904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 19, 2014 at 10:05:49AM -0700, Paul E. McKenney wrote:
> If you mean what I think you mean by load_acquire_depends(), it is spelled
> "rcu_dereference()" or, in this case, where you are never removing anything
> that has been added, "rcu_dereference_raw()".  Because you are never
> removing anything, you don't need rcu_read_lock() or rcu_read_unlock(),
> thus you don't want lockdep yelling at you about not having RCU read-side
> critical sections, thus rcu_dereference_raw().

Yeah, along that line but it's kinda weird to use rcu_dereference()
when RCU isn't involved.  It'd be clearer to have something like
load_acquire_depends() and then define RCU deref in terms of it.

This is purely notational and clarifiying in the documentation is
probably enough.

Thanks.

-- 
tejun
