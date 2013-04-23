Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3DWRhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:37:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53460 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3DWRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:37:35 -0400
Date: Tue, 23 Apr 2013 13:37:32 -0400 (EDT)
Message-Id: <20130423.133732.2222922370397287096.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: David.Laight@aculab.com, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, tytso@mit.edu, linux-kernel@vger.kernel.org,
        x86@kernel.org, netdev@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Unsigned widening casts of binary "not" operations..
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
References: <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
	<CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Apr 2013 10:37:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Apr 2013 08:42:49 -0700

> An explicit cast fixes it, and shows that you were aware of the issue:
> 
>    foo &= ~(foo_t)bar;
> 
> and gcc will generate the right logic. Of course, casts then have
> their own problems, which your thing avoids (as would just having a
> "andn" operation in C)

I just want to mention that this is dangerous in different ways, we
just recently got a patch in the networking that removed such a cast.
The problem is when the cast narrows, f.e.:

	~(u8)0

doesn't do what you think it does.  That doesn't evaluate to 0xff.

You all are very bright and probably know this already.

So,if it widens, which is the situation we're talking about, you're
good.  But until I saw the above u8 thing I never suspected that
narrowing in this kind of expression was dangerous.
