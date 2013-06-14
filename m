Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3FNWrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:47:16 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41264 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3FNWrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1371249104.1758.20.camel@buesod1.americas.hpqcorp.net>
References: <1371165333.27102.568.camel@schen9-DESK>
	<1371167015.1754.14.camel@buesod1.americas.hpqcorp.net>
	<1371226197.27102.594.camel@schen9-DESK>
	<1371249104.1758.20.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 14 Jun 2013 15:47:13 -0700
Message-ID: <CANN689GtHw6dDeMd+2fuUz_dv_Z44XndVj2u-TNy70qkZWkpDw@mail.gmail.com>
Subject: Re: Performance regression from switching lock to rw-sem for anon-vma tree
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        "Shi, Alex" <alex.shi@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 3:31 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> A few ideas that come to mind are avoiding taking the ->wait_lock and
> avoid dealing with waiters when doing the optimistic spinning (just like
> mutexes do).
>
> I agree that we should first deal with the optimistic spinning before
> adding the MCS complexity.

Maybe it would be worth disabling the MCS patch in mutex and comparing
that to the rwsem patches ? Just to make sure the rwsem performance
delta isn't related to that.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
