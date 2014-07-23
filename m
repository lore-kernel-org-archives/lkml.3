Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbaGWSbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:31:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:38245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841AbaGWSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:31:18 -0400
Date: Wed, 23 Jul 2014 20:31:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723183117.GF3935@laptop>
References: <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
 <20140723170324.GZ3935@laptop>
 <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
 <CA+55aFz9z=58iEj3qx4Oip=iPYxzgSaPe945Xzd8Z60_v1EEzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9z=58iEj3qx4Oip=iPYxzgSaPe945Xzd8Z60_v1EEzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:07:40AM -0700, Linus Torvalds wrote:

>  - *static* per-cpu allocations might want to use "cpumask_var_t" (to
> avoid having a full "struct cpumask_t") along with doing a
> "zalloc_cpumask_var_node(..)" for each cpu.
> 
> sched_init() follows that last pattern, except it open-codes that
> zalloc_cpumask_var_node() in an odd way that confused me.
> 
> So I take my patch back. It's wrong, because it only allocates that
> cpumask_size() if CONFIG_CPUMASK_OFFSTACK is true.

What it doesn't do is keep the allocation on the right node, so killing
that stuff is helping more than just readability.
