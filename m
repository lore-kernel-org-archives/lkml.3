Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3IYDcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:32:21 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36263 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3IYDcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:32:20 -0400
Message-ID: <1380079935.2163.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v5 0/6]  rwsem: performance optimizations
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Date: Tue, 24 Sep 2013 20:32:15 -0700
In-Reply-To: <1380061341.3467.49.camel@schen9-DESK>
References: <1380061341.3467.49.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 15:22 -0700, Tim Chen wrote:
> We have incorporated various suggestions from Ingo for version 5 of this patchset
> and will like to have it merged if there are no objections.
> 
> In this patchset, we introduce two categories of optimizations to read
> write semaphore.  The first four patches from Alex Shi reduce cache bouncing of the
> sem->count field by doing a pre-read of the sem->count and avoid cmpxchg
> if possible.
> 
> The last two patches introduce similar optimistic spinning logic as
> the mutex code for the writer lock acquisition of rwsem.

Right. We address the general 'mutexes out perform writer-rwsems'
situations that has been seen in more than one case. Users now need not
worry about performance issues when choosing between these two locking
mechanisms.

Thanks,
Davidlohr


