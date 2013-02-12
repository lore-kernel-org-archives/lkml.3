Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3BLFwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:52:30 -0500
Received: from ozlabs.org ([203.10.76.45]:35132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3BLFw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:52:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nick Piggin" <npiggin@kernel.dk>,
        Stewart Smith <stewart@flamingspork.com>
Subject: Re: RFC: mincore: add a bit to indicate a page is dirty.
In-Reply-To: <20130211162701.GB13218@cmpxchg.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au> <20130211162701.GB13218@cmpxchg.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 12 Feb 2013 16:19:29 +1030
Message-ID: <87pq06f5ee.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Mon, Feb 11, 2013 at 01:43:03PM +1030, Rusty Russell wrote:
>> I am writing an app which really wants to know if a file is on the
>> disk or not (ie. do I need to sync?).
>
> When the page is under writeback, it's not necessarily on disk yet,
> but you also don't need to sync.  Which semantics make more sense?
>
> I'm leaning toward checking both PG_dirty and PG_writeback.

If it's already under PG_writeback, you probably still need to wait for
it to finish if you're trying to ensure write ordering. ie. sync.

I've updated my patch by stealing your code.

Thanks!
Rusty.
