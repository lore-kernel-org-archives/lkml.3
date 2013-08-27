Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3H0XuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:50:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3H0XuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:50:12 -0400
Date: Tue, 27 Aug 2013 16:50:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] Move might_sleep and friends from kernel.h to
 sched.h
Message-Id: <20130827165011.b46c71b618e5cdc444af2804@linux-foundation.org>
In-Reply-To: <1376687844-19857-5-git-send-email-andi@firstfloor.org>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
	<1376687844-19857-5-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013 14:17:22 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> These are really related to scheduling, so they should be in sched.h
> Users usually will need to schedule anyways.
> 
> The advantage of having them there is that we can access some of the
> scheduler inlines to make their fast path more efficient. This will come
> in a followon patch.

alpha allmodconfig:

mm/memory.c:4236: error: redefinition of 'might_fault'
include/linux/sched.h:2485: note: previous definition of 'might_fault' was here

Presumably because CONFIG_PROVE_LOCKING=n && CONFIG_DEBUG_ATOMIC_SLEEP=y.

That code is too tangly for me to fix it up with any confidence, sorry.

