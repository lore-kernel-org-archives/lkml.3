Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaAZElt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 23:41:49 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63549 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 23:41:48 -0500
Date: Sat, 25 Jan 2014 20:41:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        penberg@kernel.org, linux@arm.linux.org.uk
Subject: Re: [linux-next][PATCH] mm: slub: work around unneeded lockdep
 warning
In-Reply-To: <20140124152023.A450E599@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1401252041120.10325@chino.kir.corp.google.com>
References: <20140124152023.A450E599@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Dave Hansen wrote:

> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The slub code does some setup during early boot in
> early_kmem_cache_node_alloc() with some local data.  There is no
> possible way that another CPU can see this data, so the slub code
> doesn't unnecessarily lock it.  However, some new lockdep asserts
> check to make sure that add_partial() _always_ has the list_lock
> held.
> 
> Just add the locking, even though it is technically unnecessary.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: David Rientjes <rientjes@google.com>
