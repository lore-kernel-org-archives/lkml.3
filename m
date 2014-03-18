Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaCRMxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:53:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59692 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCRMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:53:03 -0400
Date: Tue, 18 Mar 2014 13:52:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Subject: Re: zram: zsmalloc calls sleeping function from atomic context
Message-ID: <20140318125245.GG22095@laptop.programming.kicks-ass.net>
References: <20140317144358.GA374@swordfish.minsk.epam.com>
 <20140317160117.9bfbfdd5128d45a80f58070c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317160117.9bfbfdd5128d45a80f58070c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:01:17PM -0700, Andrew Morton wrote:
> btw, I note that vunmap() itself already has a might_sleep() in it, and
> I can't work out why - I don't think it _does_ sleep.  The changelog to
> 34754b69a6f87aa6aa is, in toto:
> 
> "x86: make vmap yell louder when it is used under irqs_disabled()"
> 
> No explanation *why*.  And why didn't it use WARN_ON(irqs_disabled())?

Man I suck.. and 5 years ago too. I can barely remember last week.

Lets see if the email archive has clues.

vmap()
  get_vm_area_caller()
    __get_vm_area_node(.gfp = GFP_KERNEL)
      kmalloc_node(gfp);


It does sleep.

https://lkml.org/lkml/2009/2/13/115
