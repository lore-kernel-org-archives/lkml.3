Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3BKWMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:12:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3BKWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:12:40 -0500
Date: Mon, 11 Feb 2013 14:12:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>
Subject: Re: RFC: mincore: add a bit to indicate a page is dirty.
Message-Id: <20130211141239.f4decf03.akpm@linux-foundation.org>
In-Reply-To: <20130211162701.GB13218@cmpxchg.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au>
	<20130211162701.GB13218@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 11:27:01 -0500
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Is PG_dirty the right choice?  Is that right for huge pages?  Should I
> > assume is_migration_entry(entry) means it's not dirty, or is there some
> > other check here?
> 
> If your only consequence of finding dirty pages is to sync, would you
> be better off using fsync/fdatasync maybe?

Yes, if the data is all on disk then an fsync() will be a no-op.  IOW,

	if (I need to fsync)
		fsync();

is equivalent to

	fsync();


Methinks we need to understand the requirement better.


Also, having to mmap the file to be able to query pagecache state is a
hack.  Whatever happened to the fincore() patch?

