Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbbAPD22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:28:28 -0500
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:60366 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbbAPD21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:28:27 -0500
Date: Thu, 15 Jan 2015 21:28:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
In-Reply-To: <20150115171634.685237a4.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1501152127220.13976@gentwo.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com> <20150115171634.685237a4.akpm@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Andrew Morton wrote:

> > I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
> > in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)
>
> I'm surprised.  preempt_disable/enable are pretty fast.  I wonder why
> this makes a measurable difference.  Perhaps preempt_enable()'s call to
> preempt_schedule() added pain?

The rest of the fastpath is already highly optimized. That is why
something like preempt enable/disable has such a disproportionate effect.

