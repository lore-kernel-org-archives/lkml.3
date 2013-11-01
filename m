Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3KARtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:49:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38712 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3KARtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:49:50 -0400
Message-ID: <1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Date: Fri, 01 Nov 2013 10:49:47 -0700
In-Reply-To: <20131101080135.GB25547@gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20131101080135.GB25547@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 09:01 +0100, Ingo Molnar wrote:
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > Patch 1 turns locking the anon_vma's root to locking itself to let it be
> > a per anon_vma lock, which would reduce contentions.
> > 
> > In the same time, lock range becomes quite small then, which is bascially
> > a call of anon_vma_interval_tree_insert(). Patch 2 turn rwsem to rwlock_t.
> > It's a patch made from Ingo, I just made some change to let it apply based on
> > patch 1.

Andrea's last input from this kind of conversion is that it cannot be
done (at least yet): https://lkml.org/lkml/2013/9/30/53

Thanks,
Davidlohr

