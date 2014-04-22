Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaDVT6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:58:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:56008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaDVT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:28 -0400
Date: Tue, 22 Apr 2014 13:56:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140422115629.GI11182@twins.programming.kicks-ass.net>
References: <cover.1395840483.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1395840483.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
> Hello,
> 
> This series is against 3.14.0-rc7.
> 
> It is amied to further improve 'percpu_ida' tags locality by taking
> into account system's CPU topology when stealing tags. That is try
> to steal from a CPU which is 'closest' to the stealing one.
> 
> I would not bother to post this, since on several system the change
> did not show any improvement, i.e. on such one:

There's is much lower level fruit to be had before doing something like
this.

  https://lkml.org/lkml/2014/1/23/257
  https://lkml.org/lkml/2014/1/23/329
  https://lkml.org/lkml/2014/1/23/343
  https://lkml.org/lkml/2014/1/23/354

I've not had time to revisit/finish them, but you should definitely
clean up the percpu_ida stuff and reduce existing contention before
going overboard.
