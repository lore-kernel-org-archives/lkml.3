Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbaITS7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:59:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbaITS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:59:05 -0400
Date: Sat, 20 Sep 2014 20:59:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 5/7] sched: Use rq->rd in sched_setaffinity() under RCU
 read lock
Message-ID: <20140920185901.GV2832@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
 <20140920165140.16299.45521.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920165140.16299.45521.stgit@localhost>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 08:51:40PM +0400, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> task_rq(p)->rd and task_rq(p)->rd->span may be used-after-free here.
> Probability of NULL pointer derefference isn't zero in this place.

I don't see NULL derefs, just use-after-free.
