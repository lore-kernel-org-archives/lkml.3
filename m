Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaADT4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 14:56:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbaADT4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 14:56:12 -0500
Date: Sat, 4 Jan 2014 14:55:55 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: John David Anglin <dave.anglin@bell.net>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@iki.fi>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix crash when using XFS on loopback
In-Reply-To: <BLU0-SMTP390C5C965F9A4FB18F1EBE97B50@phx.gbl>
Message-ID: <alpine.LRH.2.02.1401041451350.21108@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com> <BLU0-SMTP390C5C965F9A4FB18F1EBE97B50@phx.gbl>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jan 2014, John David Anglin wrote:

> On 4-Jan-14, at 12:45 PM, Mikulas Patocka wrote:
> 
> > * flush_dcache_page asks for the list of userspace mappings, however that
> > page->mapping field is reused by the slab subsystem for a different
> > purpose. This causes the crash.
> 
> I'd noticed the other day that the parisc implementation of
> flush_dcache_page()
> should return if "!mapping || mapping != page->mapping" is true.  This would
> have avoided crash.
> 
> Dave

I think no.

page_mapping returns NULL if the page has only anonymous mapping and it is 
not placed in the swap cache. In this case, you need to flush the kernel 
cache.

Maybe you could skip cache flush if the page is neither anonymous nor 
file-backed, but I haven't seen this condition in other architectures' 
flush_dcache_page.

Mikulas
