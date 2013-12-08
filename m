Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3LHHQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 02:16:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3LHHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 02:16:41 -0500
Date: Sat, 7 Dec 2013 23:18:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: Bug in tty cooked mode kernel 3.12.3
Message-ID: <20131208071811.GA12028@kroah.com>
References: <20131107184607.eklhad@comcast.net>
 <20131208053621.GA6445@kroah.com>
 <20131108011609.eklhad@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108011609.eklhad@comcast.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 01:16:09AM -0500, Karl Dahlke wrote:
> As per your direction, I applied Peters patch to n_tty.c,
> which looked like it was in the ballpark, echoing newline etc,
> but it did not fix the problem.
> It is still reproducible on my system as below.
> 
> > Come up in run level 3, command line mode,
> > and bring up two consoles with bash in cooked mode.
> > Set a simple prompt like this.
> >
> > PS1='$ '
> >
> > Switch to console 2 via alt-f2.
> > Hit return.
> > The cursor should drop to a new line then give you the $ prompt.
> > But it puts the $ prompt next too the old one, then drops down
> > to a blank line.
> > The $ prompt and the crlf are out of sequence.
> > Hit return a few more times and it will straighten itself out.
> > Then switch back to console 1 alt-f1
> > Hit return and the same bug,
> > $ $
> >
> > hit return a few more times to straighten it out.
> > Switch back to console 2 and the same problem.
> 
> Thank you for your quick reply,and the patch to try.
> I'm afraid however this is still an unsolved problem.
> Realize that it pops up rarely and randomly in just about any cooked program;
> I chose the console switch example because it most reliably reproduces the bug.

Ah, sorry, wrong patch series.

Search lkml for:
	Subject: [PATCH tty-next 0/4] tty: Fix ^C echo
for a 4 patch series that should resolve this issue.  If you could test
that out, and let us know, that would be great.

thanks,

greg k-h
