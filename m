Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaIIQS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:18:29 -0400
Received: from fieldses.org ([174.143.236.118]:58446 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbaIIQS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:18:26 -0400
Date: Tue, 9 Sep 2014 12:18:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Jeff Layton <jlayton@poochiereds.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Message-ID: <20140909161820.GH1776@fieldses.org>
References: <5405FBAE.5020303@parallels.com>
 <20140902184456.GC31793@fieldses.org>
 <54061562.4080306@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54061562.4080306@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> > Would it make sense to return the lock type held instead, so you could
> > do one flock(fd, LOCK_TEST) instead of flock(fd, LOCK_TEST|LOCK_SH) and
> > flock(fd, LOCK_TEST|LOCK_EX) ?
> 
> Well, in our case we parse /proc/locks anyway to see what
> files at least to test for being locked. But what you propose
> looks even better. I'll look what can be done here.

Actually I think I prefer your version.  It seems cleaner to define
LOCK_TEST as returning the same result as you'd get if you actually
tried the lock, just without applying the lock.  It avoids having a
different return-value convention for this one command.  It might avoid
some ambiguity in cases where the flock might be denied for reasons
other than a conflicting flock (e.g. on NFS where flocks and fcntl locks
conflict).  It's closer to what GETLK does in the fcntl case.

--b.
