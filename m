Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3FKPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:19:40 -0400
Received: from a10-48.smtp-out.amazonses.com ([54.240.10.48]:35171 "EHLO
	a10-48.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061Ab3FKPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:19:39 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2013 11:19:39 EDT
Date: Tue, 11 Jun 2013 15:08:48 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with
 __GFP_NOWARN
In-Reply-To: <51B67553.6020205@oracle.com>
Message-ID: <0000013f33c83e5f-946866ad-d2d3-48e6-8035-6eaf1ac37fbe-000000@email.amazonses.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com> <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com> <51B62F6B.8040308@oracle.com> <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
 <51B67553.6020205@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.11-54.240.10.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Sasha Levin wrote:

> > There must be another reason. Lets fix this.
>
> My, I feel silly now.
>
> I was the one who added __GFP_NOFAIL in the first place in
> 2ccd4f4d ("pipe: fail cleanly when root tries F_SETPIPE_SZ
> with big size").
>
> What happens is that root can go ahead and specify any size
> it wants to be used as buffer size - and the kernel will
> attempt to comply by allocation that buffer. Which fails
> if the size is too big.

Could you check that against a boundary? Use vmalloc if larger than a
couple of pages? Maybe PAGE_COSTLY_ORDER or so?

THe higher the order the more likely it is that the allocation will fail.
The PAGE_ORDER_COSTLY (or so) is a reasonable limit as to what size of a
linear contiguous allocation that can be expected to be successful.


