Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaLQSwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:52:09 -0500
Received: from www.sr71.net ([198.145.64.142]:42395 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaLQSwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:52:04 -0500
Message-ID: <5491D0D2.5070103@sr71.net>
Date: Wed, 17 Dec 2014 10:52:02 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: post-3.18 performance regression in TLB flushing code
References: <5490A5F8.6050504@sr71.net> <20141217100810.GA3461@arm.com> <CA+55aFyVxOw0upa=At6MmiNYEHzfPz4rE5bZUBCs9h4vKGh1iA@mail.gmail.com> <20141217165310.GJ870@arm.com>
In-Reply-To: <20141217165310.GJ870@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 08:53 AM, Will Deacon wrote:
> On Wed, Dec 17, 2014 at 04:28:23PM +0000, Linus Torvalds wrote:
>> On Wed, Dec 17, 2014 at 2:08 AM, Will Deacon <will.deacon@arm.com> wrote:
>> So why not just this trivial patch, to make the logic be the same it
>> used to be (just using "end > 0" instead of the old "need_flush")?
> 
> Looks fine to me... Dave?

First of all, this is quite observable when testing single-threaded on a
desktop.  This is a mildly crusty Sandybridge CPU from 2011.  I made 3
runs with a single thread: ./brk1_processes -s 30 -t 1

	   fb7332a9fed : 4323385
	   fb7332a9fed^: 4503736
fb7332a9fed+Linus's fix: 4516761

These things are also a little bit noisy, so we're well within the
margin of error with Linus's fix.

This also holds up on the large system.
