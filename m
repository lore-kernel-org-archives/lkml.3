Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaE0UtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:49:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59096 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaE0UtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:49:07 -0400
Date: Tue, 27 May 2014 13:49:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap : NUMA aware allocation for zswap_dstmem
In-Reply-To: <1401209749.5367.245.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1405271346190.14064@chino.kir.corp.google.com>
References: <1401209749.5367.245.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> zswap_dstmem is a percpu block of memory, which should
> be allocated using kmalloc_node(), to get better NUMA
> locality.
> 
> Without it, all the blocks are allocated from a single node.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: David Rientjes <rientjes@google.com>

cpu_to_node(cpu) should return the correct node that was parsed from the 
SRAT on x86 at boot during CPU_UP_PREPARE.  If any platform returns 
NUMA_NO_NODE, the worst case scenario is that we get local allocation 
anyway.
