Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaF3WD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:03:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33401 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaF3WDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:03:24 -0400
Date: Mon, 30 Jun 2014 15:03:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
Message-ID: <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
References: <53AAFDF7.2010607@oracle.com> <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Christoph Lameter wrote:

> On Wed, 25 Jun 2014, Sasha Levin wrote:
> 
> > [  791.669480] ? init_object (mm/slub.c:665)
> > [  791.669480] setup_object.isra.34 (mm/slub.c:1008 mm/slub.c:1373)
> > [  791.669480] new_slab (mm/slub.c:278 mm/slub.c:1412)
> 
> So we just got a new page from the page allocator but somehow cannot
> write to it. This is the first write access to the page.
> 

I'd be inclined to think that this was a result of "slub: reduce duplicate 
creation on the first object" from -mm[*] that was added the day before 
Sasha reported the problem.

It's not at all clear to me that that patch is correct.  Wei?

Sasha, with a revert of that patch, does this reproduce?

 [*] http://ozlabs.org/~akpm/mmotm/broken-out/slub-reduce-duplicate-creation-on-the-first-object.patch
