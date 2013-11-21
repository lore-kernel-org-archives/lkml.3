Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3KUNHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:07:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:45228 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754424Ab3KUNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:07:21 -0500
Date: Thu, 21 Nov 2013 08:07:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131121130715.GC8044@home.goodmis.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <20131119064948.GA32025@gmail.com>
 <20131119191034.GF29695@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119191034.GF29695@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:10:34PM +0100, Andi Kleen wrote:
> 
> Self modifying code is by definition x86 specific.

How so? Ftrace works on several archs, and does so with self modifying code.

> 
> Very likely any other method to do this would be Linux specific
> in some form or another, as there doesn't seem to be any
> existing art.

Seems you need to solve a catch-22 on this. You need to show that there's a
need (application), that requires this new feature and also show that all the
existing kernel features are inefficient for what is needed.

The catch-22 may be that a application wont be created without the feature,
but that's the problem you need to solve.

Personally, I rather see the userspace patching be completele separate from
the kernel space patching, as the kernel space patching must not be
complicated by any requirement of userspace patching.

I don't see how userspace doesn't need anything but a CPU sync call to do
the required sync. Add a breakpoint, sync, change the code, sync, remove
breakpoint, done!

And as a bonus, doing this in userspace could easily extend it. Say you want
to do special things with that breakpoint handler.

-- Steve
