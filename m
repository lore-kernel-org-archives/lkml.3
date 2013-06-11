Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3FKQNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:13:19 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44606 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3FKQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:13:18 -0400
Message-ID: <1370967193.3252.47.camel@edumazet-glaptop>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Jun 2013 09:13:13 -0700
In-Reply-To: <51B745F9.9080609@oracle.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
	 <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>
	 <51B62F6B.8040308@oracle.com>
	 <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
	 <51B67553.6020205@oracle.com>
	 <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>
	 <51B72323.8040207@oracle.com>
	 <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
	 <51B73F38.6040802@kernel.org>
	 <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>
	 <51B745F9.9080609@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 11:44 -0400, Sasha Levin wrote:
> On 06/11/2013 11:23 AM, Christoph Lameter wrote:
> > On Tue, 11 Jun 2013, Pekka Enberg wrote:
> >
> >> So you're OK with going forward with Sasha's patch? It's needed
> >> because __GFP_NOWARN was specifically added there to fix this
> >> issue earlier.
> >
> > Why dont we fix the call site to use vmalloc instead for larger allocs?
> >
> 
> We should probably be doing both.

Allowing a pipe to store thousands of page refs seems quite useless and
dangerous.

Having to use vmalloc()/vfree() for every splice()/vmsplice() would be a
performance loss anyway.

(fs/splice.c splice_grow_spd() will also want to allocate big kmalloc()
chunks)




