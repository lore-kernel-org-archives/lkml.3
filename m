Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaIKAZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:25:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaIKAZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:25:00 -0400
Date: Wed, 10 Sep 2014 17:24:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
Message-ID: <20140911002410.GA11732@kroah.com>
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com>
 <20140911000343.GA5328@kroah.com>
 <5410E8A2.5030802@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5410E8A2.5030802@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 08:11:14PM -0400, Peter Hurley wrote:
> On 09/10/2014 08:03 PM, Greg Kroah-Hartman wrote:
> > On Wed, Sep 10, 2014 at 05:28:19PM -0400, Peter Hurley wrote:
> >> This patch changes user-space behavior (for the better) but I'm not sure
> >> that it's consequence-free. Also, it might not be enough to unwedge the
> >> terminal if the driver got its own flow control state mangled.
> >>
> >> Thoughts?
> >>
> >> --- >% ---
> >> Subject: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
> >>
> >> If terminal flow has been stopped, the terminal can be unwedged
> >> by:
> >> 	tcflow(fd, TCOOFF);
> >> 	tcflow(fd, TCOON);
> >> This works because tcflow(TCOOFF) ensures that ->flow_stopped is set,
> >> which allows tcflow(TCOON) to override the terminal flow state in
> >> __start_tty().
> >>
> >> Instead, allow unwedging with only:
> >>         tcflow(fd, TCOON);
> >> by disregarding the existing ->flow_stopped state.
> > 
> > I don't see the benifit here, what are you trying to solve?  Sending one
> > extra tcflow command?
> 
> It's not common knowledge (and its certainly counterintuitive) that
> turning off output when output is already turned off (ie., tcflow(TCOOFF))
> is the required trickery to unwedge a terminal.
> 
> Unwedging directly seems the straightforward approach.

What's the odds we break POSIX with this type of change?

I'm all for working around broken hardware in the kernel, but this seems
like a very old issue, if it's even one at all, that we would be
changing for no one who has reported it (that I know of...)

In other words, I'm really leary of changing userspace functionality
without having a real need/reason to.

thanks,

greg k-h
