Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbbAMABt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:01:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbbAMABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:01:48 -0500
Date: Mon, 12 Jan 2015 16:01:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, gthelen@google.com
Subject: Re: +
 mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
 added to -mm tree
Message-Id: <20150112160147.27f5431a4674129690bff073@linux-foundation.org>
In-Reply-To: <20150112235438.GA27349@phnom.home.cmpxchg.org>
References: <54b45b27.XjEauKOqAygxldaJ%akpm@linux-foundation.org>
	<20150112235438.GA27349@phnom.home.cmpxchg.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 18:54:38 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > +++ a/mm/memcontrol.c
> > @@ -5337,7 +5337,7 @@ static int memory_low_show(struct seq_fi
> >  	unsigned long low = ACCESS_ONCE(memcg->low);
> >  
> >  	if (low == 0)
> > -		seq_printf(m, "none\n");
> > +		seq_puts(m, "none\n");
> >  	else
> >  		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
> 
> Hm, is that really an improvement to the code?  With seq_printf() the
> calls in both branches align visually much nicer, IMO.

No, agree that it's visually worse.  But puts() is faster and has a
much smaller cache footprint.
