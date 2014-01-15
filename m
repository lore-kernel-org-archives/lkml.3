Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaAOAgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:36:52 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:54989 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaAOAgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:36:47 -0500
Date: Tue, 14 Jan 2014 16:36:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 0 PID: 0 at mm/slub.c:1511
 __kmem_cache_create()
In-Reply-To: <52D5746F.2040604@intel.com>
Message-ID: <alpine.DEB.2.02.1401141634580.3375@chino.kir.corp.google.com>
References: <20140114131915.GA26942@localhost> <52D5746F.2040604@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=c65c1877bd6826ce0d9713d76e30a7bed8e49f38
> 
> I think the assert is just bogus at least in the early case.
> early_kmem_cache_node_alloc() says:
>  * No kmalloc_node yet so do it by hand. We know that this is the first
>  * slab on the node for this slabcache. There are no concurrent accesses
>  * possible.
> 
> Should we do something like the attached patch?  (very lightly tested)
> 

Yeah, I think that's the best option to keep the runtime checking to 
ensure the proper lock is held on debug kernels with lockdep enabled and 
is better than reverting back to the comment.
