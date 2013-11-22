Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3KVD0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:26:06 -0500
Received: from one.firstfloor.org ([193.170.194.197]:35013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3KVD0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:26:03 -0500
Date: Fri, 22 Nov 2013 04:26:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131122032600.GJ29695@two.firstfloor.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <20131119064948.GA32025@gmail.com>
 <20131119191034.GF29695@two.firstfloor.org>
 <20131121130715.GC8044@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121130715.GC8044@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems you need to solve a catch-22 on this. You need to show that there's a
> need (application), that requires this new feature and also show that all the

Patching code is quite common these days.

I'm just stating that.

> existing kernel features are inefficient for what is needed.

I believe it's possible to do it without kernel support, just hard and
ugly. 

So the idea was: the kernel already knows how to do it. It does it
in a (not perfect but reasonable way). Let's just export it.

Will make everyone's live easier. 

Is a single place so if any changes are needed they are all
centralized. If there are ever any new bugs in this area
they could be worked around in a single place.

It's too hard to leave it to user space programmers @-)

> 
> The catch-22 may be that a application wont be created without the feature,
> but that's the problem you need to solve.

Of course the applications get created, they just likely have extremly
subtle bugs if they don't quite conform to the official protocol.

Or they may suddenly break when running on some new CPUs which
has different requirements.

-Andi
