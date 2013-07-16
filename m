Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3GPD3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3GPD3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:29:17 -0400
Date: Mon, 15 Jul 2013 23:28:41 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
        xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716032841.GB1578@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
	xfs@oss.sgi.com
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:
 
 
 > And looking more at that, I'm actually starting to think this is an
 > XFS locking problem. XFS really should not call back to splice while
 > holding the inode lock.
 > 
 > But that XFS code doesn't seem new either. Is XFS a new thing for you
 > to test with?

I started pounding on it fairly recently and have shook out a number
of bugs (now fixed) since I started, so relatively new, but on the order of 'months' now.

	Dave

