Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbAUWo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:44:58 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:40380 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUWov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:44:51 -0500
Date: Wed, 21 Jan 2015 14:44:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bryton Lee <brytonlee01@gmail.com>
cc: Christoph Lameter <cl@linux.com>, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move MACRO SLAB_NEVER_MERGE and SLAB_MERGE_SAME to
 file linux/slab.h
In-Reply-To: <CAC2pzGd_p37Pi53ZEQShMj9BAECPXZCsxQwm=kKLACwmSBB99w@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1501211443410.2716@chino.kir.corp.google.com>
References: <CAC2pzGe9Q+19LpyFPwr8+TZ02XfCqwrQzsEsJA8WWB6XhuJyeQ@mail.gmail.com> <alpine.DEB.2.11.1501062114240.5674@gentwo.org> <CAC2pzGd_p37Pi53ZEQShMj9BAECPXZCsxQwm=kKLACwmSBB99w@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Bryton Lee wrote:

> thanks for review my patch.
> 
> I want to move these macros to linux/slab.h cause I don't want perform
> merge in slab level.   for example. ss read /proc/slabinfo to finger out
> how many requests pending in the TCP listern queue.  it  use slabe name
> "tcp_timewait_sock_ops" search in /proc/slabinfo, although the name is
> obsolete. so I committed other patch  to iproute2, replaced
> tcp_timewait_sock_ops by request_sock_TCP, but it still not work, because
> slab request_sock_TCP  merge into kmalloc-256.
> 
> how could I prevent this merge happen.  I'm new to kernel, this is my first
> time submit a kernel patch, thanks!
> 

Any bit in SLAB_NEVER_MERGE will cause the allocator to not merge the slab 
caches, it's not necessary to all of them be set as it seems you're 
implying.
