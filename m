Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaAWGOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:14:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaAWGOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:14:03 -0500
Date: Thu, 23 Jan 2014 01:13:43 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140123061343.GB15206@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:06:14PM -0800, David Rientjes wrote:
 > On Thu, 23 Jan 2014, Tang Chen wrote:
 > 
 > > Dave found that the kernel will hang during boot. This is because
 > > the nodemask_t type stack variable numa_kernel_nodes is large enough
 > > to overflow the stack.
 > > 
 > > This doesn't always happen. According to Dave, this happened once
 > > in about five boots. The backtrace is like the following:
 > > 
 > > dump_stack
 > > panic
 > > ? numa_clear_kernel_node_hotplug
 > > __stack_chk_fail
 > > numa_clear_kernel_node_hotplug
 > > ? memblock_search_pfn_nid
 > > ? __early_pfn_to_nid
 > > numa_init
 > > x86_numa_init
 > > initmem_init
 > > setup_arch
 > > start_kernel
 > > 
 > > This patch fix this problem by defining numa_kernel_nodes as a
 > > static global variable in __initdata area.
 > > 
 > > Reported-by: Dave Jones <davej@redhat.com>
 > > Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
 > > Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
 > 
 > I guess it depends on what Dave's CONFIG_NODES_SHIFT is?

It's 10, because I had MAXSMP set.

So, MAX_NUMNODES = 1 << 10

And the bitmask is made of longs. 1024 of them.

How does this work ?

	Dave

