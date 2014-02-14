Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBNPUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:20:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50836 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaBNPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:20:48 -0500
Date: Fri, 14 Feb 2014 15:20:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214152028.GT18016@ZenIV.linux.org.uk>
References: <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140212214411.GQ18016@ZenIV.linux.org.uk>
 <20140213205146.GS18016@ZenIV.linux.org.uk>
 <20140214132503.GA23265@infradead.org>
 <52FE1A3A.9090301@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FE1A3A.9090301@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:29:30PM +0100, Richard Weinberger wrote:
> Am 14.02.2014 14:25, schrieb Christoph Hellwig:
> > On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
> >> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
> >>
> >>> I'll try to put something along those lines together, if you or Oleg don't
> >>> do it first.
> >>
> >> OK, having looked at that stuff...
> >>
> >> 1) things become much more compact if we finish conversion to get_signal()
> >> first.
> > 
> > I have vague memories that Richard sent out a series to convert over all
> > architectures a while ago.  Hopefully he has better memory than I do.
> 
> Yeah. Sending v2 of that series is on my overflowing TODO list. :-\
> I think this is a good reason for me to start working on that series again.
> Stay tuned.

Would be great.   I have several done here, but I'll be glad to replace them
with something tested...

BTW, Oleg, could you explain why does PTRACE_PEEK_SIGINFO copy ->si_code
separately?  IOW, why do we want the upper 16 bits of ->si_code exposed?
It used to be a strictly internal thing IIRC (it's been what, 2.3.late?)
