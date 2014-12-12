Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaLLSb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:31:59 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:45248 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933905AbaLLSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:31:56 -0500
Date: Fri, 12 Dec 2014 12:31:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        penberg@kernel.org, iamjoonsoo@lge.com,
        Alexander Duyck <alexander.h.duyck@redhat.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <20141212113909.6747e273@redhat.com>
Message-ID: <alpine.DEB.2.11.1412121230450.27051@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141211183758.22e224a0@redhat.com> <20141212113909.6747e273@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014, Jesper Dangaard Brouer wrote:

> Crash/OOM during IP-forwarding network overload test[1] with pktgen,
> single flow thus activating a single CPU on target (device under test).

Hmmm... Bisected it and the patch that removes the page pointer from
kmem_cache_cpu causes in a memory leak. Pretty obvious with hackbench.


