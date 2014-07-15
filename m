Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaGOO0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:26:15 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:43679 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbaGOO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:26:13 -0400
Date: Tue, 15 Jul 2014 09:26:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 14/21] mm: slub: kasan: disable kasan
 when touching unaccessible memory
In-Reply-To: <20140715081852.GL11317@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1407150924320.10593@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-15-git-send-email-a.ryabinin@samsung.com> <20140715060405.GI11317@js1304-P5Q-DELUXE> <53C4DA54.3010502@samsung.com> <20140715081852.GL11317@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Joonsoo Kim wrote:

> > I think putting disable/enable only where we strictly need them might be a problem for future maintenance of slub.
> > If someone is going to add a new function call somewhere, he must ensure that it this call won't be a problem
> > for kasan.
>
> I don't agree with this.
>
> If someone is going to add a slab_pad_check() in other places in
> slub.c, we should disable/enable kasan there, too. This looks same
> maintenance problem to me. Putting disable/enable only where we
> strictly need at least ensures that we don't need to care when using
> slub internal functions.
>
> And, if memchr_inv() is problem, I think that you also need to add hook
> into validate_slab_cache().
>
> validate_slab_cache() -> validate_slab_slab() -> validate_slab() ->
> check_object() -> check_bytes_and_report() -> memchr_inv()

I think adding disable/enable is good because it separates the payload
access from metadata accesses. This may be useful for future checkers.
Maybe call it something different so that this is more generic.

metadata_access_enable()

metadata_access_disable()

?

Maybe someone else has a better idea?


