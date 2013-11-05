Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3KEAjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:39:18 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8627 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KEAjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:39:17 -0500
Message-ID: <1383611954.2342.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/3] mm,vdso: preallocate new vmas
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        aswin@hp.com, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:39:14 -0800
In-Reply-To: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew - 

On Thu, 2013-10-17 at 17:50 -0700, Davidlohr Bueso wrote:
> Linus recently pointed out[1] some of the amount of unnecessary work 
> being done with the mmap_sem held. This patchset is a very initial 
> approach on reducing some of the contention on this lock, and moving
> work outside of the critical region.
> 
> Patch 1 adds a simple helper function.
> 
> Patch 2 moves out some trivial setup logic in mlock related calls.
> 
> Patch 3 allows managing new vmas without requiring the mmap_sem for
> vdsos. While it's true that there are many other scenarios where
> this can be done, few are actually as straightforward as this in the
> sense that we *always* end up allocating memory anyways, so there's really
> no tradeoffs. For this reason I wanted to get this patch out in the open.

If you have no objections, could you pickup patches 1 and 2? I think
it's safe to say that patch 3 isn't worth any more discussion.

Thanks!

