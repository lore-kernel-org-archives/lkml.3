Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279Ab3BNBbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:31:25 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45756 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3BNBbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:31:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130213144932.GA14260@gmail.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
	<511B9B4F.3060404@intel.com>
	<20130213144932.GA14260@gmail.com>
Date: Wed, 13 Feb 2013 17:31:23 -0800
Message-ID: <CANN689FJcUZq1wcVZXO+jLOHOeCPnOf5kfYgYVykG6-YLSjj7g@mail.gmail.com>
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
From: Michel Lespinasse <walken@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, linux-kernel@vger.kernel.org,
        anton@samba.org, hpa@zytor.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 6:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Alex Shi <alex.shi@intel.com> wrote:
>
>> On 02/09/2013 10:45 AM, Michel Lespinasse wrote:
>> > This proposal implements writer lock stealing in lib/rwsem.c, just as
>> > Alex Shi's earlier proposal did for the simpler lib/rwsem-spinlock.c
>>
>> Ops, my patch in tip/urgent is for rwsem. Yuanhan's patch is
>> for rwsem-spinlock.

Sorry, my bad. Looks like an email snafu on my side - when I wanted to
save your patch to look through it with more context, I ended up
saving Yuanhan's instead.

> Your rwsem patch is queued up for v3.9, in the tip:core/locking
> tree:
>
>   3a15e0e0cdda rwsem: Implement writer lock-stealing for better scalability
>
> Michel, mind having a look at that and possibly generate a delta
> patch, if your patch has changes we should apply?

The main difference I can see is that my approach makes it possible to
steal the rwsem in a fast path, without going through the lib/rwsem.c
slow path. A few things fall out from that; most notably I had to
change the readers_only side of __rwsem_do_wake() to account with the
possibility of write lock stealing on the fast path, while Alex
doesn't since he forces write lock stealing to use the slow path.
Overall, my changes are more extensive but they also reduce the total
line count, while Alex's proposal goes the other way.

For these reasons, I think I still prefer my approach. However as
mentioned, this is not the best time for me to push it as I'll be away
for a little while. I should be able to get back to this in a couple
weeks, though.

Alex, could you go through my patch and see if there is anything you
find objectionable ? (if not about the details, at least about the
general approach of enabling writer lock stealing on the fast path)

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
