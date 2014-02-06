Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBFFmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:42:14 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36614 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBFFmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:42:13 -0500
Date: Thu, 6 Feb 2014 06:42:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140206054209.GA18884@gmail.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
 <20140206005534.GA27848@node.dhcp.inet.fi>
 <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> No, I was thinking "try to optimistically map 8 adjacent aligned 
> pages at a time" - that would be the same cacheline in the page 
> tables, so it would be fairly cheap if we couple it with a 
> gang-lookup of the pages in the page cache (or, for anonymous pages, 
> by just optimistically trying to do an order-3 page allocation, and 
> if that works, just map the 32kB allocation you got as eight 
> individual pages).
> 
> I know it's been discussed at some point, and I even have a dim 
> memory of having seen some really ugly patches.

I have a dim memory of having written such group-prefaulting patches 
myself a decade ago or so - IIRC the main problem was that at that 
time we never found a common load where it really mattered, and it was 
easy to spend more time doing all this extra work and not see the 
prefaulted pages used.

But the cost/benefit balance has indeed changed so IMO it's worth a 
try.

Thanks,

	Ingo
