Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaJVS74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:59:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaJVS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:59:54 -0400
Date: Wed, 22 Oct 2014 14:59:50 -0400 (EDT)
Message-Id: <20141022.145950.1585224138048242923.davem@davemloft.net>
To: oleg@redhat.com
Cc: peterz@infradead.org, cl@linux.com, tkhai@yandex.ru, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, vdavydov@parallels.com
Subject: Re: introduce probe_slab_address?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141022181412.GA8159@redhat.com>
References: <20141022161450.GA27607@redhat.com>
	<20141022163743.GI21513@worktop.programming.kicks-ass.net>
	<20141022181412.GA8159@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 11:59:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>
Date: Wed, 22 Oct 2014 20:14:12 +0200

> So perhaps something like this makes sense?
> 
> If some arch has problems with D-cache aliasing (because the freed page
> can be already mapped by user-space or vmalloc'ed), it can redefine this
> helper.
> 
> Do you think we can use it to access rq->curr? (although let me repeat
> that I won't really argue with SLAB_DESTROY_BY_RCU).

Do we really need this?

We fully initialize and read from the area using the same virtual
address, there is no possiblity for corruption from SLAB's
perspective.

It's when you store at vaddr X then read at vaddr Y and expect to see
what you wrote at X that you have problems.

That is very much not what is happening here.

The lifetime is contained to SLAB's usage at one single virtual
address.
