Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaKSUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:25:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38387 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:25:58 -0500
Date: Wed, 19 Nov 2014 15:25:55 -0500 (EST)
Message-Id: <20141119.152555.528973700550634768.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patches][RFC] situation with csum_and_copy_... API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141118194053.GA14641@ZenIV.linux.org.uk>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
	<20141118194053.GA14641@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:25:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 18 Nov 2014 19:40:53 +0000

> On Tue, Nov 18, 2014 at 08:47:45AM +0000, Al Viro wrote:
> 
>> I do have a patch doing just that; the question is what to do with csum-and-copy
>> primitives.  Originally I planned to simply strip those access_ok() from those
>> (both the explicit calls and use of copy_from_user() where we ought to use
>> __copy_from_user(), etc.), but that's not nice to potential out-of-tree callers
>> of those suckers.  If any of those exist and manage to cope with the wonderful
>> calling conventions, that is.  As it is, we have the total of 4 callers of
>> csum_and_copy_from_user() and 2 callers of csum_and_copy_to_user(), all in
>> networking code.  Do we care about potential out-of-tree users existing and
>> getting screwed by such change?  Davem, Linus?
> 
> FWIW, the beginning of series in question follows; removal of those
> access_ok() is 3/5.  The series is longer than that (see vfs.git#iov_iter-net
> for a bit more, and there's more stuff in local queue still too much in flux
> to push them out), but all the stuff relevant to validating iovecs on
> sendmsg/recvmsg and getting rid of excessive access_ok() is in the first 5
> commits.

Al I really like this series, especially patch #2.

Sorry for taking so long to review this, I just wanted to make sure we
got this right.

Can you give me a pull request for just these 5 patches?  Then feel free
to post the next batch for review, I'm eager to see it as are others.

Thanks!
