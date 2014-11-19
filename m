Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaKSUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:31:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbaKSUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:31:38 -0500
Date: Wed, 19 Nov 2014 15:31:36 -0500 (EST)
Message-Id: <20141119.153136.867017618826698045.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] situation with csum_and_copy_... API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141118212307.GU7996@ZenIV.linux.org.uk>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
	<CA+55aFxK0wj2LLp0WmhRsBZch8XfoYbzmbEeJaMpt=SDh5GBvw@mail.gmail.com>
	<20141118212307.GU7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:31:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 18 Nov 2014 21:23:07 +0000

> On Tue, Nov 18, 2014 at 12:49:13PM -0800, Linus Torvalds wrote:
>> "access_ok()" isn't that expensive, and removing them as unnecessary
>> is fraught with errors. We've had several cases of "oops, we used
>> __get_user() in a loop, because it generates much better code, but
>> we'd forgotten to do access_ok(), so now people can read kernel data".
> 
> OK...  If netdev folks can live with that for now, I've no problem with
> dropping 3/5.  However, I really think we need a variant of csum-and-copy
> that would _not_ bother with access_ok() longer term.  That can wait, though...

I think because of the way Al verifies things at the top level, and
how we structure access to these msg->msg_iov so strictly, these cases
of access_ok() really can safely go.

But that is just my opinion, and yes I do acknowledge that we've had
serious holes in this area in the past.
