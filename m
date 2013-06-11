Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3FKWKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:10:17 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64831 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3FKWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:10:15 -0400
Date: Tue, 11 Jun 2013 15:10:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@gentwo.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with
 __GFP_NOWARN
In-Reply-To: <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.02.1306111509250.6141@chino.kir.corp.google.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com> <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com> <51B62F6B.8040308@oracle.com> <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
 <51B67553.6020205@oracle.com> <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com> <51B72323.8040207@oracle.com> <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Christoph Lameter wrote:

> > I think that leaving the warning makes sense to catch similar
> > things which are actually bugs - we had a similar issue with
> > /dev/kmsg (if I remember correctly) which actually pointed to
> > a bug.
> 
> Right. Requesting an allocation larger than even supported by the page
> allocator from the slab allocators that are specializing in allocations of
> small objects is usually an indication of a problem in the code.
> 

I think we can remove the kmalloc_slab() warning that Sasha is pointing to 
and just fallback to the page allocator for sizes that are too large?  
Then the page allocator can return NULL and warn, if necessary, for orders 
larger than MAX_ORDER.
