Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaIOLhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:37:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaIOLhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:37:52 -0400
Date: Mon, 15 Sep 2014 13:37:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Preeti Murthy <preeti.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
Message-ID: <20140915113747.GC2840@worktop.localdomain>
References: <1410519814.3569.7.camel@tkhai>
 <CAM4v1pPWKpoRjGqms8wXhMs0B1iLeVnUJRZu3iOW9Dy_44dCKQ@mail.gmail.com>
 <1410775350.3569.51.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410775350.3569.51.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 02:02:30PM +0400, Kirill Tkhai wrote:
> Hi, Preeti,
> 
> В Пн, 15/09/2014 в 15:18 +0530, Preeti Murthy пишет:
> > Hi Kirill,
> > 
> > Which tree is this patch based on? __migrate_task() does a
> > double_rq_lock/unlock() today in mainline, doesn't it? I don't
> > however see that in your patch.
> 
> it's based on recent tip tree:
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/
> 
> Also, once I received a build-robot message about my patch
> makes warning on allyesconfig, and since that time I learned
> about Peter's tree :) 
> 
> https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git
> 
> (This is for info, I don't know if it is right to make patches
> based on in. But really good if you was away for some time
> and you're interested in recent news without lkml archive reading.
> I use it :)

Its mostly a scratch tree to get some build coverage and to show people
what all is queued up in my quilt tree. The tree is fully recreated
every time I export my queue and at times I forget to export.

So feel free to look at, but basing work on it might not be the bestest
idea. Ideally things should find their way into -tip fairly quickly (or
get dropped on the ground if they come apart, but that usually goes
paired with an email telling you about the borkage).
