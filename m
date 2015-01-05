Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbbAEOwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:52:36 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:48934 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbbAEOwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:52:34 -0500
Date: Mon, 5 Jan 2015 08:52:30 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
In-Reply-To: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1501050852060.24090@gentwo.org>
References: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Joonsoo Kim wrote:

> Now, I reach the solution to remove preempt enable/disable in the fastpath.
> If tid is matched with kmem_cache_cpu's tid after tid and kmem_cache_cpu
> are retrieved by separate this_cpu operation, it means that they are
> retrieved on the same cpu. If not matched, we just have to retry it.

Acked-by: Christoph Lameter <cl@linux.com>
