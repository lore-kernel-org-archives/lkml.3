Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaGJOH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:07:58 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:33877 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbaGJOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:07:57 -0400
Date: Thu, 10 Jul 2014 09:07:53 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 11/21] mm: slub: share slab_err and
 object_err functions
In-Reply-To: <53BE4398.6020509@samsung.com>
Message-ID: <alpine.DEB.2.11.1407100907131.12483@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-12-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.11.1407090928530.1384@gentwo.org> <53BE4398.6020509@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Andrey Ryabinin wrote:

> On 07/09/14 18:29, Christoph Lameter wrote:
> > On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> >
> >> Remove static and add function declarations to mm/slab.h so they
> >> could be used by kernel address sanitizer.
> >
> > Hmmm... This is allocator specific. At some future point it would be good
> > to move error reporting to slab_common.c and use those from all
> > allocators.
> >
>
> I could move declarations to kasan internals, but it will look ugly too.
> I also had an idea about unifying SLAB_DEBUG and SLUB_DEBUG at some future.
> I can't tell right now how hard it will be, but it seems doable.

Well the simple approach is to first unify the reporting functions and
then work the way up to higher levels. The reporting functions could also
be more generalized to be more useful for multiple checking tools.

