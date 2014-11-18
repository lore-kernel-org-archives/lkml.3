Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaKRTk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:40:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53953 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaKRTk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:40:57 -0500
Date: Tue, 18 Nov 2014 19:40:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: netdev@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [patches][RFC] situation with csum_and_copy_... API
Message-ID: <20141118194053.GA14641@ZenIV.linux.org.uk>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118084745.GT7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 08:47:45AM +0000, Al Viro wrote:

> I do have a patch doing just that; the question is what to do with csum-and-copy
> primitives.  Originally I planned to simply strip those access_ok() from those
> (both the explicit calls and use of copy_from_user() where we ought to use
> __copy_from_user(), etc.), but that's not nice to potential out-of-tree callers
> of those suckers.  If any of those exist and manage to cope with the wonderful
> calling conventions, that is.  As it is, we have the total of 4 callers of
> csum_and_copy_from_user() and 2 callers of csum_and_copy_to_user(), all in
> networking code.  Do we care about potential out-of-tree users existing and
> getting screwed by such change?  Davem, Linus?

FWIW, the beginning of series in question follows; removal of those
access_ok() is 3/5.  The series is longer than that (see vfs.git#iov_iter-net
for a bit more, and there's more stuff in local queue still too much in flux
to push them out), but all the stuff relevant to validating iovecs on
sendmsg/recvmsg and getting rid of excessive access_ok() is in the first 5
commits.
