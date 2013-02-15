Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3BOWed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:34:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3BOWeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:34:31 -0500
Date: Fri, 15 Feb 2013 14:34:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] mm: fincore()
Message-Id: <20130215143430.958b78ab.akpm@linux-foundation.org>
In-Reply-To: <20130215222803.GA23930@cmpxchg.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au>
	<20130211162701.GB13218@cmpxchg.org>
	<20130211141239.f4decf03.akpm@linux-foundation.org>
	<20130215063450.GA24047@cmpxchg.org>
	<20130215131451.138e83ce.akpm@linux-foundation.org>
	<20130215222803.GA23930@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 17:28:03 -0500
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Yes, and there will be immediate calmour to add more goodies to the
> > other seven bits.  PageDirty, referenced state, etc.  We should think
> > about this now, at the design stage rather than grafting things on
> > later.
> 
> I'm interested in your "etc.".  PG_error, PG_active, PG_writeback,
> page huge?

Gawd knows.  How many crazy people are there out there?

If we adopt my use-runlength-encoding suggestion then things get
easier.  We add an extra arg to the syscall which selects which
particular per-page boolean we're looking for and can gather up to 4
billion different PageFoo()s.

