Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaLQPgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:36:16 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:38558 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaLQPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:36:15 -0500
Date: Wed, 17 Dec 2014 09:36:13 -0600 (CST)
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
In-Reply-To: <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412170935480.2047@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141215075933.GD4898@js1304-P5Q-DELUXE> <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Joonsoo Kim wrote:

> Ping... and I found another way to remove preempt_disable/enable
> without complex changes.
>
> What we want to ensure is getting tid and kmem_cache_cpu
> on the same cpu. We can achieve that goal with below condition loop.
>
> I ran Jesper's benchmark and saw 3~5% win in a fast-path loop over
> kmem_cache_alloc+free in CONFIG_PREEMPT.
>
> 14.5 ns -> 13.8 ns
>
> See following patch.

Good idea. How does this affect the !CONFIG_PREEMPT case?
