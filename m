Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaKSXqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:46:08 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51098 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbaKSXqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:46:06 -0500
Date: Wed, 19 Nov 2014 15:46:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
In-Reply-To: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Andrey Ryabinin wrote:

> kmem_cache_zalloc_node() allocates zeroed memory for a particular
> cache from a specified memory node. To be used for struct irq_desc.
> 

Is there a reason to add this for such a specialized purpose to the slab 
allocator?  I think it can just be handled for struct irq_desc explicitly.
