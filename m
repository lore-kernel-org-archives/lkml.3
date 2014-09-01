Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaIAXNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:13:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIAXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:13:08 -0400
Date: Tue, 2 Sep 2014 00:13:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] ufs: fix deadlocks after mutex merge
Message-ID: <20140901231306.GL7996@ZenIV.linux.org.uk>
References: <1409610624-10898-1-git-send-email-khoroshilov@ispras.ru>
 <20140901230835.GK7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901230835.GK7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:08:35AM +0100, Al Viro wrote:

> Your commit message makes no sense - ufs_evict_inode() is *never* called
> with that lock held, for one thing.  I agree that "ufs: sb mutex merge +
> mutex_destroy" was been badly broken and apparently never tested, though -
> the bugs are real.
> 
> 	Please, write a saner commit message; what happens is that
> ufs_{new,free}_inode() take the damn lock themselves these days, so
> their caller shouldn't do that.

PS: after rereading your mail, I see what you meant to say, but it really
wasn't clear enough.  The crucial part is that the lock is *always* taken
by free/new, not that some of the callers take it and some do not.
