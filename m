Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab3GPULE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:11:04 -0400
Received: from 1wt.eu ([62.212.114.60]:34756 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab3GPULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:11:01 -0400
Date: Tue, 16 Jul 2013 22:10:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130716201041.GC20721@1wt.eu>
References: <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk> <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com> <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com> <1374000084.6458.36.camel@gandalf.local.home> <20130716191147.GA1680@kroah.com> <1374003789.6458.55.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374003789.6458.55.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 03:43:09PM -0400, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 12:11 -0700, Greg Kroah-Hartman wrote:
> 
> > People mark stable patches that way already today with a:
> > 	Cc: stable <stable@vger.kernel.org> # delay for 3.12-rc4
> > or some such wording.  I take those and don't apply them until the noted
> > release happens, so you can do this if needed.
> 
> I guess the thing is, are stable patches prone to regressions. Do we
> just do that for patches that we think are too complex and may cause
> some harm. Of course, there's the question about having a clue about
> what patches might cause harm or not.

We'd probably better switch the tag to be "# now" to imply that we don't
want to delay them, and that by default those merged prior to rc4 are all
postponed. I suspect that the switching could be mostly automated this way,
avoiding to add burden to Greg :

  - if commit ID >= -rc4
    move to immediate queue, it's a "critical" fix as per Linus' rules

  - if Cc: stable line has "now" at the end, move to immediate queue as
    the maintainer takes this reponsibility ;

  - otherwise move to the next .2 queue.

Willy

