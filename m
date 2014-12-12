Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031208AbaLLRXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:23:21 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55676 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030941AbaLLRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:23:18 -0500
Date: Fri, 12 Dec 2014 09:23:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: linux-next: build failure after merge of the rcu tree
Message-ID: <20141212172312.GT25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141212171215.6beff7b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212171215.6beff7b4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121217-0017-0000-0000-0000070FEE94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 05:12:15PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build (powerpc64
> allnoconfig) failed like this:
> 
> In file included from arch/powerpc/include/asm/kvm_ppc.h:30:0,
>                  from arch/powerpc/kernel/setup_64.c:68:
> include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
>   struct srcu_struct srcu;
>                      ^
> include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
>   struct srcu_struct irq_srcu;
>                      ^
> 
> I am sure we have seen this before :-(
> 
> Caused by commit 31a78b1b598a ("srcu: Isolate srcu sections using
> CONFIG_SRCU") as it was before (I do wonder why this came back).
> 
> I have reverted that commit for today.

Gah...  I forgot to adjust rcu/next placement for the merge window!!!
Please accept my apologies, I have set it up to include only the
commits destined for 3.19.  :-/

							Thanx, Paul

