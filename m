Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaHLTOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:14:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41470 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaHLTOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:14:49 -0400
Date: Tue, 12 Aug 2014 20:14:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 0/4] VFS revoke()
Message-ID: <20140812191444.GW18016@ZenIV.linux.org.uk>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 08:54:04PM +0200, David Herrmann wrote:

> Open questions:
>  * Obviously, we need to protect all calls into file->f_op->xyz(). This series
>    provides enter_file() and leave_file() that can be used like:
>       if (enter_file(file))
>           retval = file->f_op->xyz(file, ...);
>       else
>           retval = -ENODEV;
>    Question is, should we do this at the time we actually invoke those
>    callbacks or should we do it at the syscall-entry time?

The former, obviously.  The real bitch is around mmap - you don't need
that for evdev, but generic solution would better deal with that kind
of crap.

I'll post a review once I'm done with Eric's patchset; hopefully tonight or
tomorrow morning.
