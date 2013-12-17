Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3LQPRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:17:40 -0500
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:33224 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354Ab3LQPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:17:38 -0500
Date: Tue, 17 Dec 2013 15:17:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
In-Reply-To: <52AF9EB9.7080606@sr71.net>
Message-ID: <0000014301223b3e-a73f3d59-8234-48f1-9888-9af32709a879-000000@email.amazonses.com>
References: <20131213235903.8236C539@viggo.jf.intel.com> <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org> <52AF9EB9.7080606@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.17-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Dave Hansen wrote:

> I'll do some testing and see if I can coax out any delta from the
> optimization myself.  Christoph went to a lot of trouble to put this
> together, so I assumed that he had a really good reason, although the
> changelogs don't really mention any.

The cmpxchg on the struct page avoids disabling interrupts etc and
therefore simplifies the code significantly.

> I honestly can't imagine that a cmpxchg16 is going to be *THAT* much
> cheaper than a per-page spinlock.  The contended case of the cmpxchg is
> way more expensive than spinlock contention for sure.

Make sure slub does not set __CMPXCHG_DOUBLE in the kmem_cache flags
and it will fall back to spinlocks if you want to do a comparison. Most
non x86 arches will use that fallback code.


