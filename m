Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3JIBUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:20:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60660 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3JIBUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:20:37 -0400
Date: Wed, 9 Oct 2013 02:20:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
Message-ID: <20131009012036.GF13318@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
 <CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
 <20131009011833.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009011833.GE13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:18:33AM +0100, Al Viro wrote:

> Point, but I would argue that we should yell very loud if we get 0 from
> vfs_write() for non-zero size.  I'm not sure if POSIX allows write(2)
> to return that, but a lot of userland code won't be expecting that and
> won't be able to cope...

PS: I agree that we should abort that loop if we get nr == 0, of course,
but I believe that we should report the pathname of the offending file,
at the very least.
