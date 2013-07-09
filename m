Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3GIRuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:50:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3GIRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:50:06 -0400
Date: Tue, 9 Jul 2013 10:50:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-Id: <20130709105032.f9acb85a.akpm@linux-foundation.org>
In-Reply-To: <20130709173242.GA9098@localhost.localdomain>
References: <20130630183349.GA23731@dhcp22.suse.cz>
	<20130701012558.GB27780@dastard>
	<20130701075005.GA28765@dhcp22.suse.cz>
	<20130701081056.GA4072@dastard>
	<20130702092200.GB16815@dhcp22.suse.cz>
	<20130702121947.GE14996@dastard>
	<20130702124427.GG16815@dhcp22.suse.cz>
	<20130703112403.GP14996@dastard>
	<20130704163643.GF7833@dhcp22.suse.cz>
	<20130708125352.GC20149@dhcp22.suse.cz>
	<20130709173242.GA9098@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013 21:32:51 +0400 Glauber Costa <glommer@gmail.com> wrote:

> > $ dmesg | grep "blocked for more than"
> > [276962.652076] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > [276962.653097] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > [276962.653940] INFO: task ld:14442 blocked for more than 480 seconds.
> > [276962.654297] INFO: task ld:14962 blocked for more than 480 seconds.
> > [277442.652123] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > [277442.653153] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > [277442.653997] INFO: task ld:14442 blocked for more than 480 seconds.
> > [277442.654353] INFO: task ld:14962 blocked for more than 480 seconds.
> > [277922.652069] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > [277922.653089] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > 
> 
> You seem to have switched to XFS. Dave posted a patch two days ago fixing some
> missing conversions in the XFS side. AFAIK, Andrew hasn't yet picked the patch.

I can't find that patch.  Please resend?

There's also "list_lru: fix broken LRU_RETRY behaviour", which I
assume we need?
