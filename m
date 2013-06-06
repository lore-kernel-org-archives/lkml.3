Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3FFFAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:00:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50026 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3FFFAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:00:06 -0400
Date: Wed, 05 Jun 2013 22:00:05 -0700 (PDT)
Message-Id: <20130605.220005.1262211330700518675.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mikey@neuling.org, luto@amacapital.net, linux-kernel@vger.kernel.org,
        x86@kernel.org, trinity@vger.kernel.org, netdev@vger.kernel.org,
        anton@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5/5] net: Block MSG_CMSG_COMPAT in send(m)msg and
 recv(m)msg
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370493325.24311.332.camel@edumazet-glaptop>
References: <aa015609319786835bcab445d507faa75c11f111.1369177867.git.luto@amacapital.net>
	<CAEjGV6xcF776C6N6VxeMY0Vyk+X51oNixdbN42-xkWjQOaMEQA@mail.gmail.com>
	<1370493325.24311.332.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 05 Jun 2013 21:35:25 -0700

> On Thu, 2013-06-06 at 12:56 +1000, Michael Neuling wrote:
>> On Thu, May 23, 2013 at 7:07 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > MSG_CMSG_COMPAT is (AFAIK) not intended to be part of the API --
>> > it's a hack that steals a bit to indicate to other networking code
>> > that a compat entry was used.  So don't allow it from a non-compat
>> > syscall.
>> 
>> Dave & Linus
>> 
>> This is causing a regression on 64bit powerpc with 32bit usermode.
>> When I hit userspace, udev is broken and I suspect all networking is
>> broken as well.
>> 
>> Can we please revert 1be374a0518a288147c6a7398792583200a67261 upstream?
>> 
> 
> It seems to also break x86_64, if using 32bit usermode.

Sorry, I only merged this because Ingo Molnar and others kept beating
me over the head about merging this fix.

Linus please revert, and I will not bow to such pressure in the future,
I should know better.

