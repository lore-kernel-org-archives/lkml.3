Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3EOPdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:33:50 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42424 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759085Ab3EOPdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:33:49 -0400
Date: Wed, 15 May 2013 10:33:48 -0500
From: Robin Holt <holt@sgi.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit 911af505 introduced a bootmem warning.
Message-ID: <20130515153348.GT3658@sgi.com>
References: <20130515075742.GL3658@sgi.com>
 <20130515143249.GH4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515143249.GH4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 07:32:49AM -0700, Paul E. McKenney wrote:
> On Wed, May 15, 2013 at 02:57:42AM -0500, Robin Holt wrote:
> > Paul,
> > 
> > When we boot Linus' current kernel we get the following warning early
> > in boot:
> > 
> > ----------------------------------------------------------------------
> > [    0.000000] Memory: 63081268k/99598336k available (4832k kernel code, 34651396k absent, 1865672k reserved, 6269k data,
> > 1672k init)
> > [    0.000000] Hierarchical RCU implementation.
> > [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> > [    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=32.
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: at mm/nobootmem.c:215 ___alloc_bootmem_nopanic+0x79/0x82()
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc1-uv-hz100-rja+ #3
> > [    0.000000] Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
> > [    0.000000]  00000000000000d7 ffffffff81a01e38 ffffffff814a873c ffffffff81a01e78
> > [    0.000000]  ffffffff81045a7b ffffffff81ced5a2 0000000000000000 ffffffffffffffff
> > [    0.000000]  0000000000000040 0000000000000200 0000000067da2bfc ffffffff81a01e88
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff814a873c>] dump_stack+0x19/0x1d
> > [    0.000000]  [<ffffffff81045a7b>] warn_slowpath_common+0x6b/0xa0
> > [    0.000000]  [<ffffffff81045ac5>] warn_slowpath_null+0x15/0x20
> > [    0.000000]  [<ffffffff81b1793a>] ___alloc_bootmem_nopanic+0x79/0x82
> > [    0.000000]  [<ffffffff81b17a59>] ___alloc_bootmem+0x11/0x3c
> > [    0.000000]  [<ffffffff81b17aa4>] __alloc_bootmem+0x10/0x12
> > [    0.000000]  [<ffffffff81b233a7>] alloc_bootmem_cpumask_var+0x1d/0x27
> > [    0.000000]  [<ffffffff81b1119b>] rcu_bootup_announce_oddness+0xd0/0x153
> > [    0.000000]  [<ffffffff81b11735>] rcu_init+0x1e/0x1e6
> > [    0.000000]  [<ffffffff81aedf2f>] start_kernel+0x1e6/0x43c
> > [    0.000000]  [<ffffffff81aedb3b>] ? repair_env_string+0x58/0x58
> > [    0.000000]  [<ffffffff81aed4d1>] x86_64_start_reservations+0x1b/0x32
> > [    0.000000]  [<ffffffff81aed612>] x86_64_start_kernel+0x12a/0x131
> > [    0.000000] ---[ end trace c8b13488e92fad65 ]---
> > [    0.000000]  Experimental no-CBs for all CPUs
> > [    0.000000]  Experimental no-CBs CPUs: 0-31.
> > [    0.000000] NO_HZ: Full dynticks CPUs: 1-31.
> 
> Could you please try the following patch and let me know if it helps?
> 
> 								Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Don't allocate bootmem from rcu_init()
> 
> When rcu_init() is called we already have slab working, allocating
> bootmem at that point results in warnings and an allocation from
> slab.  This commit therefore changes alloc_bootmem_cpumask_var() to
> alloc_cpumask_var() in rcu_bootup_announce_oddness(), which is called
> from rcu_init().
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Tested-by: Robin Holt <holt@sgi.com>

Works great.

Robin
