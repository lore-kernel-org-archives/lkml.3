Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaDMPzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 11:55:50 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49432 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaDMPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 11:55:49 -0400
Date: Sun, 13 Apr 2014 17:55:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander.Kleinsorge@gmx.de
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Re: new module to check constant memory for corruption
Message-ID: <20140413155547.GD22728@two.firstfloor.org>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
 <87eh12hr1t.fsf@tassilo.jf.intel.com>
 <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> your question: there are no writes in this write protected adress range (e.g. kernel code).

It's actually not true, Linux changes r/o code. But you could
handle that by hooking into the right places.

> my idea is to calculate a checksum (xor is fastest) over this range and check later (periodically) if its unchanged.
> see source code download (5 KB): http://tauruz.homeip.net/ramcheck.tgz
> the code is working fine and the checksum is (as expected) constant (at least for many hours).
> 

So is the goal security or reliability or debugging?

Reliability:
I have doubts it makes sense for that. On most system the code
is only a very small part of the total memory. So you wouldn't
cover most data.

Also if something corrupts the code we likely already detect it
eventually by crashing. Your module would need to panic too in this
case.

Security: If someone can change the code what stops them from changing
the checksum module too?

Also if you use a poor (= fast) checksum it's likely easy to construct
a valid patch that does not change the checksum.

Debugging:
Maybe, but I have never seen a bug where code got corrupted.

The user program technique works reasonably well for finding bad
pointers. Write a program that allocates a lot of memory. Regularly
checksum and recheck all its memory.


-Andi
