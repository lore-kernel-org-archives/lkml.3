Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaA1AdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:33:02 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:34566 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA1AdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:33:00 -0500
Date: Mon, 27 Jan 2014 16:32:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
In-Reply-To: <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, David Rientjes wrote:

> >  arch/x86/mm/numa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> > index 81b2750..ebefeb7 100644
> > --- a/arch/x86/mm/numa.c
> > +++ b/arch/x86/mm/numa.c
> > @@ -562,10 +562,10 @@ static void __init numa_init_array(void)
> >  	}
> >  }
> >  
> > +static nodemask_t numa_kernel_nodes __initdata;
> >  static void __init numa_clear_kernel_node_hotplug(void)
> >  {
> >  	int i, nid;
> > -	nodemask_t numa_kernel_nodes;
> >  	unsigned long start, end;
> >  	struct memblock_type *type = &memblock.reserved;
> >  
> 
> Isn't this also a bugfix since you never initialize numa_kernel_nodes when 
> it's allocated on the stack with NODE_MASK_NONE?
> 

This hasn't been answered and the patch still isn't in linux-kernel yet 
Dave tested it as good.  I'm suspicious of the changelog that indicates 
this nodemask is the result of a stack overflow itself which only manages 
to reproduce itself in the init patch slightly more than 50% of the time.  
How is that possible?

I think the changelog should indicate this also fixes an uninitialized 
nodemask issue.
