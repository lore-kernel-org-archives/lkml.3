Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaJUCAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbaJUCAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:00:46 -0400
Date: Mon, 20 Oct 2014 22:00:33 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20141021020033.GA8486@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
 <20140529072633.GH6677@dastard>
 <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
 <20140529235308.GA14410@dastard>
 <20140530000649.GA3477@redhat.com>
 <20140530002113.GC14410@dastard>
 <20140530003219.GN10092@bbox>
 <20140530013414.GF14410@dastard>
 <5388A2D9.3080708@zytor.com>
 <CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:41:00AM -0700, Linus Torvalds wrote:
 > On Fri, May 30, 2014 at 8:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
 > >
 > > If we removed struct thread_info from the stack allocation then one
 > > could do a guard page below the stack.  Of course, we'd have to use IST
 > > for #PF in that case, which makes it a non-production option.
 > 
 > We could just have the guard page in between the stack and the
 > thread_info, take a double fault, and then just map it back in on
 > double fault.
 > 
 > That would give us 8kB of "normal" stack, with a very loud fault - and
 > then an extra 7kB or so of stack (whatever the size of thread-info is)
 > - after the first time it traps.
 > 
 > That said, it's still likely a non-production option due to the page
 > table games we'd have to play at fork/clone time.

[thread necrophilia]

So digging this back up, it occurs to me that after we bumped to 16K,
we never did anything like the debug stuff you suggested here.

The reason I'm bringing this up, is that the last few weeks, I've been
seeing things like..

[27871.793753] trinity-c386 (28793) used greatest stack depth: 7728 bytes left

So we're now eating past that first 8KB in some situations.

Do we care ? Or shall we only start worrying if it gets even deeper ?

	Dave

