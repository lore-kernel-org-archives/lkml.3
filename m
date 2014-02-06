Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaBFSJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:09:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaBFSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:09:35 -0500
Date: Thu, 6 Feb 2014 19:09:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
Message-ID: <20140206180930.GJ5002@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
 <20140206135001.333583247@infradead.org>
 <CA+55aFwzn09dPJekgCbO2VRO8j3=eEt2j_QFd=Gd4MXTA2gm9g@mail.gmail.com>
 <20140206175201.GH5002@laptop.programming.kicks-ass.net>
 <CA+55aFx=dDhYzp7yN5oiPT+_Gyffo+0hT5WRFd7eGeMz8oNnDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx=dDhYzp7yN5oiPT+_Gyffo+0hT5WRFd7eGeMz8oNnDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 09:56:54AM -0800, Linus Torvalds wrote:
> On Thu, Feb 6, 2014 at 9:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> It's the "_return" variants. As far as I can tell, there are exactly
> ZERO users of that stuff, and they are BAD BAD BAD.
> 
> On x86, those things would cause a cmpxchg loop, and the bad
> read-for-shared-before-acquire cacheline pattern.
> 
> So why indirectly encourage people to add users for a bad operation?

OK, I'll not generate the _return() variants.
