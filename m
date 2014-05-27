Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaE0Oep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:34:45 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:43988 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbaE0Oeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:34:44 -0400
Date: Tue, 27 May 2014 09:34:22 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
In-Reply-To: <20140527102909.GO30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405270929550.13999@gentwo.org>
References: <20140526145605.016140154@infradead.org> <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com> <20140526203232.GC5444@laptop.programming.kicks-ass.net> <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
 <20140527102909.GO30445@twins.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Peter Zijlstra wrote:

> The things I care about for VM_PINNED are long term pins, like the IB
> stuff, which sets up its RDMA buffers at the start of a program and
> basically leaves them in place for the entire duration of said program.

Ok that also means the pages are not to be allocated from ZONE_MOVABLE?

I expected the use of a page flag. With a vma flag we may have a situation
that mapping a page into a vma changes it to pinned and terminating a
process may unpin a page. That means the zone that the page should be
allocated from changes.

Pinned pages in ZONE_MOVABLE are not a good idea. But since "kernelcore"
is rarely used maybe that is not an issue?




