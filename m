Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbbAIDeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:34:11 -0500
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:53771 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbbAIDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:34:10 -0500
Date: Thu, 8 Jan 2015 21:34:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
In-Reply-To: <20150108074447.GA25453@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1501082133350.22140@gentwo.org>
References: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com> <1420513392.24290.2.camel@stgolabs.net> <20150106080948.GA18346@js1304-P5Q-DELUXE> <1420563737.24290.7.camel@stgolabs.net> <20150108074447.GA25453@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Joonsoo Kim wrote:

> > You'd need a smp_wmb() in between tid and c in the loop then, which
> > looks quite unpleasant. All in all disabling preemption isn't really
> > that expensive, and you should redo your performance number if you go
> > this way.
>
> This barrier() is not for read/write synchronization between cpus.
> All read/write operation to cpu_slab would happen on correct cpu in
> successful case. What I'd need to guarantee here is to prevent
> reordering between fetching operation for correctness of algorithm. In
> this case, barrier() seems enough to me. Am I wrong?

You are right.

