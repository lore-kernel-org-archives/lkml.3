Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaLQToZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:44:25 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:41334 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbaLQToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:44:24 -0500
Date: Wed, 17 Dec 2014 13:44:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <alpine.DEB.2.11.1412170953280.8347@gentwo.org>
Message-ID: <alpine.DEB.2.11.1412171339450.29803@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141215075933.GD4898@js1304-P5Q-DELUXE> <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com> <alpine.DEB.2.11.1412170953280.8347@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Christoph Lameter wrote:

> On Wed, 17 Dec 2014, Joonsoo Kim wrote:
>
> > +       do {
> > +               tid = this_cpu_read(s->cpu_slab->tid);
> > +               c = this_cpu_ptr(s->cpu_slab);
> > +       } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));

Here is another one without debugging:

   0xffffffff811d23bb <+59>:	mov    %gs:0x8(%r9),%rdx		tid(rdx) = this_cpu_read()
   0xffffffff811d23c0 <+64>:	mov    %r9,%r8
   0xffffffff811d23c3 <+67>:	add    %gs:0x7ee37d9d(%rip),%r8         c (r8) =
   0xffffffff811d23cb <+75>:	cmp    0x8(%r8),%rdx			c->tid == tid
   0xffffffff811d23cf <+79>:	jne    0xffffffff811d23bb <kmem_cache_alloc+59>

Actually that looks ok.

