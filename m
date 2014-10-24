Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaJXOly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:41:54 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:45708 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654AbaJXOlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:51 -0400
Date: Fri, 24 Oct 2014 09:41:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: Re: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for
 RT)
In-Reply-To: <20141024045630.GD15243@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1410240938460.29214@gentwo.org>
References: <20141022155517.560385718@linux.com> <20141023080942.GA7598@js1304-P5Q-DELUXE> <alpine.DEB.2.11.1410230916090.19494@gentwo.org> <20141024045630.GD15243@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I found that you said retrieving tid first is sufficient to do
> things right in old discussion. :)

Right but the tid can be obtained from a different processor.


One other aspect of this patchset is that it reduces the cache footprint
of the alloc and free functions. This typically results in a performance
increase for the allocator. If we can avoid the page_address() and
virt_to_head_page() stuff that is required because we drop the ->page
field in a sufficient number of places then this may be a benefit that
goes beyond the RT and CONFIG_PREEMPT case.


