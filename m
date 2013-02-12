Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3BLGlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:41:24 -0500
Received: from ozlabs.org ([203.10.76.45]:44999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab3BLGlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:41:22 -0500
Date: Tue, 12 Feb 2013 17:41:21 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
Message-ID: <20130212064121.GA19354@concordia>
References: <20130102153744.GC25940@redhat.com>
 <20130118205358.GA6854@redhat.com>
 <20130118210728.GA16742@kroah.com>
 <50FB0957.2000400@suse.cz>
 <1359570837.3325.30.camel@thor.lan>
 <20130211024412.GA7623@concordia>
 <1360593750.25941.13.camel@thor.lan>
 <20130212020039.GA8979@concordia>
 <1360637638.4415.13.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360637638.4415.13.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 09:53:58PM -0500, Peter Hurley wrote:
> On Tue, 2013-02-12 at 13:00 +1100, Michael Ellerman wrote:
> > > Can you reproduce after using the following patch series?
> > > [PATCH v3 00/23] ldisc fixes
> > 
> > What are they against? I tried Linus' tree and linux-next but they
> > didn't apply cleanly against either.
> 
> The series was generated against next-20130204. 13/23 doesn't apply
> cleanly at next-20130211 because of changes since. Rebases fine
> though :)

Should have tried harder against next, git-am is very picky.

So running next-20130211, 20 runs of trinity followed by ctrl-c, I saw
the warning 12 times. Back trace is basically always:

Call Trace:
[c00000027a1efb20] [c000000000467b74] .flush_to_ldisc+0x244/0x250 (unreliable)
[c00000027a1efbd0] [c00000000009ea7c] .process_one_work+0x1bc/0x4f0
[c00000027a1efc70] [c00000000009f2e0] .worker_thread+0x180/0x4b0
[c00000027a1efd30] [c0000000000a6c3c] .kthread+0xec/0x100
[c00000027a1efe30] [c000000000009f64] .ret_from_kernel_thread+0x64/0x80


Running next-20130211 + "ldisc fixes", 20 runs of trinity followed by ctrl-c,
I saw the warning _0_ times.

Insert standard comment about testing only proving the presence of bugs not
their absence :)

So it looks promising.

cheers
