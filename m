Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3FZP0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:26:09 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56026 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3FZP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:26:06 -0400
Date: Wed, 26 Jun 2013 08:25:53 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130626152553.GB4405@mtj.dyndns.org>
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130625225759.GI3828@linux.vnet.ibm.com>
 <20130625230938.GB30407@mtj.dyndns.org>
 <20130626141752.GK3828@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626141752.GK3828@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 07:17:52AM -0700, Paul E. McKenney wrote:
> > Do you mean something like the following?
> > 
> > 	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
> > 	  likely(__ptr != __next) ? \
> > 		list_entry_rcu(__next, type, member) : NULL; \
> > 
> > Yeah, that looks right to me.
> 
> I would feel much better about this!  Does it avoid warnings in your
> use cases?

Yeah, it does, and more importantly it adds the missing read barrier
during RCU deref.  I'll give it another test and post the updated
version.

Thanks a lot!

-- 
tejun
