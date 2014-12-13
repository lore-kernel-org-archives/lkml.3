Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaLMXjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:39:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58260 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaLMXja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:39:30 -0500
Date: Sat, 13 Dec 2014 23:39:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213233918.GO22149@ZenIV.linux.org.uk>
References: <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 02:59:43PM -0800, Linus Torvalds wrote:
> Side note: I think I've found a real potential lockup bug in
> fs/namespace.c, but afaik it could only trigger with the RT patches.

> Except it won't with the RT patches, I guess. So it looks like you could have:\
> 
>  - mnt_make_readonly() sets that bit
>  - gets preempted with the RT patches
>  - we run mnt_want_write() on all CPU's, which disables preemption and
> waits for the bit to be cleared
>  - nothing happens.
> 
> This is clearly not what happens in your lockup, but it does seem to
> be a potential issue for the RT kernel.
> 
> Added Al and Thomas to the cc, for fs/namespace.c and RT kernel
> respectively. Maybe the RT patches already fix this, I didn't actually
> check.

I agree that it's a thing to keep in mind on the RT side of things, but
IMO it belongs in RT patches...
