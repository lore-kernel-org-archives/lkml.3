Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3FLNBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:01:45 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:51791 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab3FLNBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:01:43 -0400
Date: Wed, 12 Jun 2013 13:01:42 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with
 __GFP_NOWARN
In-Reply-To: <1370968655.3252.49.camel@edumazet-glaptop>
Message-ID: <0000013f387a3aa2-aa8535ad-b76e-4fd3-8a6b-19e98cc19104-000000@email.amazonses.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>   <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>   <51B62F6B.8040308@oracle.com>   <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
   <51B67553.6020205@oracle.com>   <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>   <51B72323.8040207@oracle.com>   <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>   <51B73F38.6040802@kernel.org>  
 <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>   <51B745F9.9080609@oracle.com> <1370967193.3252.47.camel@edumazet-glaptop>  <51B74E28.4070906@oracle.com> <1370968655.3252.49.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.12-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Eric Dumazet wrote:

> Yes and no : adding a test to select vmalloc()/vfree() instead of
> kmalloc()/kfree() will slow down regular users asking 32 pages in their
> pipe.

But vmalloc would allow buffers larger than MAX_PAGE_ORDER. The allocation
would not fail. You could have 1G or so pipes if necessary.

> If there is no _sensible_ use for large pipes even for root, please do
> not bloat the code just because we can.

Some code bloat to enable super sized pipes may be ok?

Huge page support could be useful to increase speed?


