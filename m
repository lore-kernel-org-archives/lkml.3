Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbaKTUDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:03:21 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:45918 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbaKTUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:03:20 -0500
Date: Thu, 20 Nov 2014 14:03:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
In-Reply-To: <546DAA99.5070402@samsung.com>
Message-ID: <alpine.DEB.2.11.1411201402050.14867@gentwo.org>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com> <546DAA99.5070402@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Andrey Ryabinin wrote:

> It could be used not only for irq_desc. Grepping sources gave me 7 possible users.
>
> We already have zeroing variants of kmalloc/kmalloc_node/kmem_cache_alloc,
> so why kmem_cache_alloc_node is special?

Why do we need this at all? You can always add the __GFP_ZERO flag and any
alloc function will then zero the memory for you.

