Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaFCO56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:57:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:48022 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbaFCO54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:57:56 -0400
Date: Tue, 3 Jun 2014 10:57:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: Dave Chinner <david@fromorbit.com>, Daniel Phillips <daniel@phunq.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603145749.GB12890@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	Dave Chinner <david@fromorbit.com>,
	Daniel Phillips <daniel@phunq.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <538B9DEE.20800@phunq.net>
 <538C360F.7020901@ontolinux.com>
 <20140603033940.GB14410@dastard>
 <538D5D78.6040102@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D5D78.6040102@ontolinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:30:32AM +0200, Christian Stroetmann wrote:
> In general, I do not believe that the complexity problems of soft updates,
> atomic writes, and related techniques can be solved by hand/manually. So my
> suggestion is to automatically handle the complexity problem of e.g.
> dependancies in a way that is comparable to a(n on-the-fly) file-system
> compiler so to say that works on a very large dependancy graph (having
> several billions of graph vertices actually). And at this point an
> abstraction like it is given with Featherstitch helps to feed and control
> this special FS compiler.

Well, if you want to try to implement something like this, go for it!

I'd be very curious to see how well (a) how much CPU overhead it takes
to crunch on a dependency graph with billions of vertices, and (b) how
easily can it be to express these dependencies and maintainable such a
dependency language would be.  Sounds like a great research topic, and
I'll note the Call For Papers for FAST 2015 is out, and if you can
solve these problems, it would make a great FAST 2015 submission:

https://www.usenix.org/conference/fast15/call-for-papers

Cheers,

					- Ted
