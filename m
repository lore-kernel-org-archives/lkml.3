Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3KSSuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:50:02 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3KSSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:49:59 -0500
Date: Tue, 19 Nov 2013 19:49:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131119184959.GE29695@two.firstfloor.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <528AF5D7.7000308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AF5D7.7000308@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I would prefer an interface which took a list of patch points,
> or implemented only the aspects which are impossible to do in user space.

We already have all the code. Why not just use it?

Note I'm not adding any new mechanism, just exporting the existing one.
So the usual "do things in user space" arguments do not really
apply here.

Also this is subtle enough that there is definitely benefit from
having only a single canonical code that does it.

If we ever need any new errata workarounds for this they could be also
all done in a single central place.

> 
> All we really need in the kernel is the IPI broadcasts - the rest can be
> done in user space, including intercepting SIGTRAP.  For userspace it is
> probably the best to just put a thread to sleep until the patching is
> done, which can be done with a futex.

I'm not sure that's worth it. IPIs are reasonably fast (a few 1000s cycles).
Sleeping likely only becomes beneficial with much longer delays, like
ms. But if the IPIs start taking ms we have much more problems.

> One advantage with doing this in userspace is that the kernel doesn't
> have to be responsible avoiding holding a thread due to a slightly
> different SIGTRAP -- it will all come out after the signal handler is
> restored, anyway.

It's just some spinning, not a new task state. I don't think any
task states make sense here.

-Andi
