Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaDWOmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:42:40 -0400
Received: from kanga.kvack.org ([205.233.56.17]:43432 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaDWOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:42:38 -0400
Date: Wed, 23 Apr 2014 10:42:37 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: Fix type of iterator variable in do_io_submit()
Message-ID: <20140423144237.GY22552@kvack.org>
References: <1398207423-21119-1-git-send-email-ebiggers3@gmail.com> <20140423141617.GE13050@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423141617.GE13050@linux.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:16:17AM -0400, Matthew Wilcox wrote:
> On Tue, Apr 22, 2014 at 05:57:03PM -0500, Eric Biggers wrote:
> > do_io_submit() iterated over the userspace iocb structure pointers using
> > a variable i of type 'int'.  This was wrong since 'nr', the number of
> > iocb structure pointers, could potentially be up to LONG_MAX /
> > sizeof(struct iocb *).  Fix it (and also remove the unnecessary
> > initialization to 0).
> 
> You're not wrong, but do we *really* want users to be able to submit
> 144115188075855872 I/Os with a single system call?  How about limiting
> them to a single billion?  Given that they have to allocate 64GB of
> *control* data structures to submit this many I/Os, I think this will
> be sufficient for many years to come.

Practically speaking, this change has no effect.  The io_submit() syscall 
will exit far before we even hit INT_MAX because of the limits on the 
number of iocbs.

		-ben
-- 
"Thought is the essence of where you are now."
