Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaDGINr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:13:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaDGINn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:13:43 -0400
Date: Mon, 7 Apr 2014 10:13:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm 2/3] lockdep: mark rwsem_acquire_read as recursive
Message-ID: <20140407081336.GC11096@twins.programming.kicks-ass.net>
References: <cover.1396779337.git.vdavydov@parallels.com>
 <8c6473e959a4557d8622a6d7ff24888cb3f7512d.1396779337.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c6473e959a4557d8622a6d7ff24888cb3f7512d.1396779337.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 07:33:51PM +0400, Vladimir Davydov wrote:
> rw_semaphore implementation allows recursing calls to down_read, but
> lockdep thinks that it doesn't. As a result, it will complain
> false-positively, e.g. if we do not observe some predefined locking
> order when taking an rw semaphore for reading and a mutex.
> 
> This patch makes lockdep think rw semaphore is read-recursive, just like
> rw spin lock.

Uhm no rwsem isn't read recursive.
