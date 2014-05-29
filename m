Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaE2XTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:19:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59281 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaE2XTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:19:23 -0400
Date: Fri, 30 May 2014 00:19:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kai <wildex999@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG?: super.c:sget spin_lock not released?
Message-ID: <20140529231921.GO18016@ZenIV.linux.org.uk>
References: <CA+jWvaKyLPfFb6b-aGCz8RhCCcsSZ+kz5Co3xSKwPOhsguHFMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+jWvaKyLPfFb6b-aGCz8RhCCcsSZ+kz5Co3xSKwPOhsguHFMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 12:49:56AM +0200, Kai wrote:
> Hello,
> 
> I have recently been playing around with writing a custom filesystem
> for Linux, and have been reading the source of other filesystems, and
> the functions they call into the linux kernel.
> While looking at the function sget in super.c I found something strange.
> 
> before if(test) it takes a spinlock, however there seems to be two
> cases where it does not unlock it.
> (Kernel 3.14, super.c line 441)
> 
> One:
> if(!grab_super(old)) goto retry;
> Will jump to before spin_lock(), without releasing it first.

Er...  So either grab_super() releases that spinlock, or that thing
is screwed.  The next obvious step would be to look into grab_super()...

> Two:
> And if it finds an old sb, it will return without releasing the lock.

... unless something it calls does just that.
