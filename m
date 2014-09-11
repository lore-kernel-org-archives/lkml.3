Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaIKN4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:56:21 -0400
Received: from imap.thunk.org ([74.207.234.97]:50897 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaIKN4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:56:17 -0400
Date: Thu, 11 Sep 2014 09:56:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
Message-ID: <20140911135610.GD15632@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com>
 <20140911000343.GA5328@kroah.com>
 <5410E8A2.5030802@hurleysoftware.com>
 <20140911002410.GA11732@kroah.com>
 <5410F08D.10707@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5410F08D.10707@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 08:45:01PM -0400, Peter Hurley wrote:
> > I'm all for working around broken hardware in the kernel, but this seems
> > like a very old issue, if it's even one at all, that we would be
> > changing for no one who has reported it (that I know of...)
> 
> How to unwedge a terminal comes up from time to time.

Are you trying to unwedge a terminal using hardware flow control, or
software flow control?

For software flow control, this is a guarantee that we can make wrt to
the behavior of tcflow().  For hardware flow control, we can't make
any guarantees, whether it's with tcflow(TCOON) or tcflow(TCOOF);
tcflow(TCOON). 

> It's possible that this may cause userspace breakage. Some app
> may call tcflow(TCOON) thus accidently overriding the flow control
> state when it would have had no effect before.

It's very likely that an application that would be using tcflow() at
all would first be sending a TCOOFF, and then sending a TCOON.  So
this doesn't worry me that much.

Indeed, given that the definition of how TCION and TCIOFF is worded
(send a START or STOP command), it's completely reasonable to
interpret TCOON and TCOOFF as emulating what would happen if the
system received a START or STOP command.  (Note though that part of
this is that Posix doesn't define CRTSCTS, so POSIX is entirely silent
on the subject of hardware flow control).

Cheers,

					- Ted
