Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaKEVHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:07:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44703 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaKEVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:07:50 -0500
Date: Wed, 5 Nov 2014 21:07:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141105210745.GT7996@ZenIV.linux.org.uk>
References: <20141105022251.GA19136@gondor.apana.org.au>
 <20141104.222727.275422581392488793.davem@davemloft.net>
 <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105.155054.2198151263164321219.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:50:54PM -0500, David Miller wrote:
> I think we can get away with it if, as you say, we don't export a 'msghdr'
> from any uapi headers.

OK.  I'm about halfway through the review of struct msghdr instances in the
current tree right now, will post user_msghdr patch once I'm done.  Already
found a dumb bug in o2net_send_tcp_msg() while doing that - broken by me
back in 3.15 ;-/  Will send a fix to Linus in an hour or so...

> And indeed, double checking, it's purely a linux/socket.h thing.
> 
> If this patch is OK, mind if I toss it into net-next Al?

Sure, no problem - AFAICS, the only real difference from rebase of April one
I've quoted upthread is that you add include of socket.h into skbuff.h; the
rest of the differences is pure whitespace noise.

Ping me when you put it there, OK?  I'll rebase the rest of old stuff on
top of it (similar helpers, mostly).
