Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBJLSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:18:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35390 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaBJLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:18:02 -0500
Date: Mon, 10 Feb 2014 11:17:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git fixes for -rc2
Message-ID: <20140210111759.GD18016@ZenIV.linux.org.uk>
References: <20140209233643.GB18016@ZenIV.linux.org.uk>
 <20140210104747.GV13997@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210104747.GV13997@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 09:47:47PM +1100, Dave Chinner wrote:

> and the updated pos value on O_APPEND writes is never folded back
> into ppos.

Not true.  Check generic_file_buffered_write() and generic_file_direct_write()
- that's where it's normally stored into iocb->ki_pos (via *ppos).  And yes,
I agree that the damn thing is obfuscated to hell and back - other commits
in my local tree kill 'ppos' arguments of __generic_file_aio_write() and
generic_file_buffered_write() (equal to &iocb->ki_pos for all call sites),
which makes it a bit easier to keep track of.  Will push that part of
queue into vfs.git#iov_iter today...
