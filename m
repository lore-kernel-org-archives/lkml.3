Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3FMVuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:50:20 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:63247 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab3FMVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:50:16 -0400
Date: Thu, 13 Jun 2013 14:50:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613215009.GF13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613190610.GA13970@mtj.dyndns.org>
 <20130613121324.2cab80256217df97254af16c@linux-foundation.org>
 <20130613192152.GC13970@mtj.dyndns.org>
 <20130613211425.GC8650@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613211425.GC8650@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rafael and Oleg)

On Thu, Jun 13, 2013 at 02:14:25PM -0700, Kent Overstreet wrote:
> Yeah, I think you're definitely right. (I only started reading up on the
> freezer stuff yesterday, though).
> 
> Do you know offhand what existing (i.e. slab) allocators do? Whatever
> they do should make sense for us.

I don't think the memory allocator does anything.  Memory allocations
are guaranteed to make forward progress and everything should still be
working while freezing, so it doesn't need to do anything special.  If
the tag allocator is to be used only by kernel proper - say drivers,
block layer, it shouldn't need to do anything special.  If it's
directly exposed to userland via something like aio and the userland
is involved in guaranteeing forward progress - ie. freeing of tags -
then the allocator would need to be able to fail, I think.

Thanks.

-- 
tejun
