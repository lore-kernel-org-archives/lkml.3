Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbaGBTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:46:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbaGBTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:46:52 -0400
Date: Wed, 2 Jul 2014 12:46:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH PING] VFS: mount must return EACCES, not EROFS
Message-Id: <20140702124651.38b315a8adce63a37fccc60e@linux-foundation.org>
In-Reply-To: <20140627082058.GA24986@frolo.macqel>
References: <20140619230924.GO4453@dastard>
	<1403253562-29248-1-git-send-email-phdm@macqel.be>
	<20140627082058.GA24986@frolo.macqel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 10:20:58 +0200 Philippe De Muyter <phdm@macqel.be> wrote:

> Currently, the initial mount of the root file system by the linux
> kernel fails with a cryptic message instead of being retried with
> the MS_RDONLY flag set,  when the device is read-only and the
> combination of block driver and filesystem driver yields EROFS.
> 
> I do not know if POSIX mandates that mount(2) must fail with EACCES, nor
> if linux aims to strict compliance with POSIX on that point.  Consensus
> amongst the messages that I have read so far seems to show that linux
> kernel hackers feel that EROFS is a more appropriate error code than
> EACCES in that case.
> 
> So, do you choose for my first pragmatic and non-intrusive patch, that
> lets mount_block_root() retry with MS_RDONLY if the file system
> returns EROFS (https://lkml.org/lkml/2014/6/18/468) or for the second
> one that forces all file-systems to return EACCES instead of EROFS.
> (https://lkml.org/lkml/2014/6/20/98).

They both seem a little hacky to me.

Isn't the core problem that "the combination of block driver and
filesystem driver yields EROFS"?  That the fs should instead be
returning EACCESS in this case?

What fs and block driver are we talking about here, anyway?
