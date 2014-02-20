Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaBUFqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 00:46:30 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:24237 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbaBUFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 00:46:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkgWAOrnBlNXQzZB/2dsb2JhbABZKIJeg0O+EAICgQ0XdIIlAQEEATocIwULCAMOCiMLOR4GE4d9DAHNSReOZAeEOAEDiUaObQGKUYdWgW+BSy8
Date: Fri, 21 Feb 2014 05:47:52 +0800
From: Fabian Frederick <fabf@skynet.be>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        cl@linux-foundation.org
Subject: Re: Has slab ctor operation changed? -- was [PATCH 1/1] afs:
 afs_alloc_inode: use kmem_cache_zalloc
Message-Id: <20140221054752.3905832359384e0f427ee9f8@skynet.be>
In-Reply-To: <32740.1392934995@warthog.procyon.org.uk>
References: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
	<32740.1392934995@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 22:23:15 +0000
David Howells <dhowells@redhat.com> wrote:

> Fabian Frederick <fabf@skynet.be> wrote:
> 
> > afs_vnode is currently cleared with 2 memsets after allocation and 
> > 1 in constructor (afs_i_init_once).
> > 	-This patch calls zalloc for explicit zero fill.
> 
> Ummm...  This patch isn't necessarily correct in the substantiative portions.
> 
> Since afs_i_init_once() is called by the slab allocator during the course of
> kmem_cache_alloc(), how does kmem_cache_zalloc() interact with that?

Object of this patch was to replace any kmem_cache_alloc by kmem_cache_zalloc
so I guess what is done in the patch v2 in afs_alloc_inode below zalloc
would be ok (leaving ctor how it is) ?

> 
> IIRC, it used to be that the ctor() function was called when the pages were
> allocated to the slab - and it wasn't called again, even if the object was
> allocated, deallocated and reallocated.  This means that things like locks and
> lists don't need reinitialising after allocation.
> 
> So afs_i_init_once() theoretically constructs the stuff that can be reused,
> and afs_alloc_inode() therefore has to clear the non-reusable state.
> 
> Of course, it's possible that the slab allocator no longer works like this...
> 
> David
