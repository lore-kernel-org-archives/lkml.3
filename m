Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3EFU0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:26:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52077 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3EFU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:26:34 -0400
Date: Mon, 6 May 2013 21:26:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] alpha: spinlock: don't perform memory access in locked
 critical section
Message-ID: <20130506202628.GN25399@ZenIV.linux.org.uk>
References: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:01:05PM +0100, Will Deacon wrote:
> The Alpha Architecture Reference Manual states that any memory access
> performed between an LD_xL and a STx_C instruction may cause the
> store-conditional to fail unconditionally and, as such, `no useful
> program should do this'.
> 
> Linux is a useful program, so fix up the Alpha spinlock implementation
> to use logical operations rather than load-address instructions for
> generating immediates.

Huh?  Relevant quote is "If any other memory access (ECB, LDx, LDQ_U,
STx_C, STQ_U, WH64x) is executed on the given processor between the
LDx_L and the STx_C, the sequence above may always fail on some
implementations; hence, no no useful programs should do this".  Where
do you see LDA in that list and why would it possibly be there?  And
no, LDx does *not* cover it - the same reference manual gives
LD{Q,L,WU,BU} as expansion for LDx, using LDAx for LD{A,AH}; it's
a separate group of instructions and it does *NOT* do any kind of
memory access.
