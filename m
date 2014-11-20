Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbaKTWbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:31:13 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65180 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbaKTWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:31:08 -0500
Date: Thu, 20 Nov 2014 14:31:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
In-Reply-To: <546DAA99.5070402@samsung.com>
Message-ID: <alpine.DEB.2.10.1411201430220.30354@chino.kir.corp.google.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com> <546DAA99.5070402@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Andrey Ryabinin wrote:

> > Is there a reason to add this for such a specialized purpose to the slab 
> > allocator?  I think it can just be handled for struct irq_desc explicitly.
> > 
> 
> It could be used not only for irq_desc. Grepping sources gave me 7 possible users.
> 

It would be best to follow in the example of those users and just use 
__GFP_ZERO.
